###############################################################################
# Infrastructure
###############################################################################

resource "azurerm_availability_set" "main" {
  name                = "mainav"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  managed             = true
}

resource "azurerm_resource_group" "main" {
  name     = "rancher-resources"
  location = var.location
}

###########
# Network #
###########

resource "azurerm_public_ip" "main" {
  count               = var.control_count
  name                = "publicip-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "lb" {
  name                = "lbpip"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_virtual_network" "main" {
  name                = "rancher-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.0.0/16"
}

resource "azurerm_network_interface" "main" {
  count               = var.control_count
  name                = "rancher-nic-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                                    = "testconfiguration1"
    subnet_id                               = azurerm_subnet.internal.id
    private_ip_address_allocation           = "Dynamic"
    public_ip_address_id                    = azurerm_public_ip.main[count.index].id
    load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.main.id]
  }
}

###########
# Compute #
###########

resource "azurerm_virtual_machine" "main" {
  count                 = 3
  name                  = "rancher-${count.index}"
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  availability_set_id   = azurerm_availability_set.main.id
  network_interface_ids = [azurerm_network_interface.main[count.index].id]
  os_profile {
    computer_name  = "rancherhost-${count.index}"
    admin_username = "ubuntu"
    custom_data    = file("${var.userdatadir}")
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path     = "/home/ubuntu/.ssh/authorized_keys"
    }
  }
  vm_size = "Standard_DS1_v2"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"

  }
  storage_os_disk {
    name          = "osdisk-${count.index}"
    create_option = "FromImage"
  }

  provisioner "local-exec" {
    command    = "sleep 120"
    on_failure = continue
  }

}

#################
# Load Balancer #
#################

resource "azurerm_lb" "main" {
  name                = "rancher"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  frontend_ip_configuration {
    name                 = "lbpip"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "backendpool"
}

resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "httpProbe"
  protocol            = "tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lb_rule_80" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "LBRule80"
  protocol                       = "tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "lbpip"
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.main.id
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.lb_probe.id
  depends_on                     = [azurerm_lb_probe.lb_probe]
}

resource "azurerm_lb_rule" "lb_rule_443" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "LBRule443"
  protocol                       = "tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "lbpip"
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.main.id
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.lb_probe.id
  depends_on                     = [azurerm_lb_probe.lb_probe]
}
