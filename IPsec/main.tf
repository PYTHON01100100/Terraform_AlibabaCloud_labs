#first config provider
/*
provider "alicloud" {
  access_key = "from the platform"
  secret_key = "from the platform"
  region = "me-central-1" #represent KSA
}

*/
resource "alicloud_vpn_gateway" "vpn_gateway_a" { 
  # Defines a VPN gateway resource for VPC A
  vpn_gateway_name = "vpn-gateway-a" 
  # Sets the name of the VPN gateway for VPC A
  vpc_id           = "vpc-l4vtf5uowx1veqr0qytqu" 
  # Associates the VPN gateway with VPC A's ID
  bandwidth        = 1 
  # Sets the maximum bandwidth for the VPN gateway (in Mbps)
  enable_ipsec     = true 
  # Enables IPsec functionality for the VPN gateway
  enable_ssl       = false 
  # Disables SSL functionality for the VPN gateway
  payment_type     = "PayAsYouGo" 
  # Configures the payment type as post-paid (Pay-As-You-Go)
}

resource "alicloud_vpn_gateway" "vpn_gateway_b" { 
  # Defines a VPN gateway resource for VPC B
  vpn_gateway_name = "vpn-gateway-b" 
  # Sets the name of the VPN gateway for VPC B
  vpc_id           = "vpc-l4v83ayzkdx4n56c36kru" 
  # Associates the VPN gateway with VPC B's ID
  bandwidth        = 1 
  # Sets the maximum bandwidth for the VPN gateway (in Mbps)
  enable_ipsec     = true 
  # Enables IPsec functionality for the VPN gateway
  enable_ssl       = false 
  # Disables SSL functionality for the VPN gateway
  payment_type     = "PayAsYouGo" 
  # Configures the payment type as post-paid (Pay-As-You-Go)
}

resource "alicloud_vpn_customer_gateway" "customer_gateway_b" { 
  # Defines a customer gateway resource representing VPC B for VPC A
  customer_gateway_name = "customer-gw-b" 
  # Sets the name of the customer gateway for VPC B
  ip_address            = alicloud_vpn_gateway.vpn_gateway_b.internet_ip 
  # Dynamically assigns the public IP of VPC B's VPN gateway
  asn                   = 65001 
  # Sets the Autonomous System Number (ASN) for the customer gateway
  description           = "Represents VPC B from A" 
  # Adds a description to identify the purpose of this customer gateway
}

resource "alicloud_vpn_customer_gateway" "customer_gateway_a" { 
  # Defines a customer gateway resource representing VPC A for VPC B
  customer_gateway_name = "customer-gw-a" 
  # Sets the name of the customer gateway for VPC A
  ip_address            = alicloud_vpn_gateway.vpn_gateway_a.internet_ip 
  # Dynamically assigns the public IP of VPC A's VPN gateway
  asn                   = 65002 
  # Sets the Autonomous System Number (ASN) for the customer gateway
  description           = "Represents VPC A from B" 
  # Adds a description to identify the purpose of this customer gateway
}

resource "alicloud_vpn_connection" "ipsec_connection_a" { 
  # Defines an IPsec connection from VPC A to VPC B
  vpn_connection_name = "ipsec-a-to-b" 
  # Sets the name of the IPsec connection
  vpn_gateway_id      = alicloud_vpn_gateway.vpn_gateway_a.id 
  # Links the connection to VPC A's VPN gateway
  customer_gateway_id = alicloud_vpn_customer_gateway.customer_gateway_b.id 
  # Links the connection to the customer gateway representing VPC B
  local_subnet        = ["172.40.1.0/24"] 
  # Specifies the local subnet in VPC A to be connected
  remote_subnet       = ["192.170.2.0/24"] 
  # Specifies the remote subnet in VPC B to be connected
  effect_immediately  = true 
  # Ensures the IPsec connection takes effect immediately

  ike_config { 
    # Configures Internet Key Exchange (IKE) settings for the IPsec connection
    ike_auth_alg = "sha1" 
    # Sets the authentication algorithm for IKE
    ike_enc_alg  = "aes" 
    # Sets the encryption algorithm for IKE
    ike_version  = "ikev1" 
    # Specifies the IKE version to use
    ike_mode     = "main" 
    # Sets the negotiation mode for IKE
    ike_lifetime = 86400 
    # Sets the lifetime of the IKE security association (in seconds)
    psk          = "MySecret123!" 
    # Sets the pre-shared key (PSK) for authentication
  }

  ipsec_config { 
    # Configures IPsec settings for the IPsec connection
    ipsec_auth_alg = "sha1" 
    # Sets the authentication algorithm for IPsec
    ipsec_enc_alg  = "aes" 
    # Sets the encryption algorithm for IPsec
    ipsec_lifetime = 86400 
    # Sets the lifetime of the IPsec security association (in seconds)
  }
}

resource "alicloud_vpn_connection" "ipsec_connection_b" { 
  # Defines an IPsec connection from VPC B to VPC A
  vpn_connection_name = "ipsec-b-to-a" 
  # Sets the name of the IPsec connection
  vpn_gateway_id      = alicloud_vpn_gateway.vpn_gateway_b.id 
  # Links the connection to VPC B's VPN gateway
  customer_gateway_id = alicloud_vpn_customer_gateway.customer_gateway_a.id 
  # Links the connection to the customer gateway representing VPC A
  local_subnet        = ["192.170.2.0/24"] 
  # Specifies the local subnet in VPC B to be connected
  remote_subnet       = ["172.40.1.0/24"] 
  # Specifies the remote subnet in VPC A to be connected
  effect_immediately  = true 
  # Ensures the IPsec connection takes effect immediately

  ike_config { 
    # Configures Internet Key Exchange (IKE) settings for the IPsec connection
    ike_auth_alg = "sha1" 
    # Sets the authentication algorithm for IKE
    ike_enc_alg  = "aes" 
    # Sets the encryption algorithm for IKE
    ike_version  = "ikev1" 
    # Specifies the IKE version to use
    ike_mode     = "main" 
    # Sets the negotiation mode for IKE
    ike_lifetime = 86400 
    # Sets the lifetime of the IKE security association (in seconds)
    psk          = "MySecret123!" 
    # Sets the pre-shared key (PSK) for authentication
  }

  ipsec_config { 
    # Configures IPsec settings for the IPsec connection
    ipsec_auth_alg = "sha1" 
    # Sets the authentication algorithm for IPsec
    ipsec_enc_alg  = "aes" 
    # Sets the encryption algorithm for IPsec
    ipsec_lifetime = 86400 
    # Sets the lifetime of the IPsec security association (in seconds)
  }
}






/*
# main.tf  -- the most correct one
resource "alicloud_vpn_gateway" "vpn_gateway_a" {
  vpn_gateway_name = "vpn-gateway-a"
  vpc_id           = "vpc-l4vtf5uowx1veqr0qytqu" 
  bandwidth        = 1
  enable_ipsec     = true
  enable_ssl       = false
  payment_type     = "PayAsYouGo" 
}

resource "alicloud_vpn_gateway" "vpn_gateway_b" {
  vpn_gateway_name = "vpn-gateway-b"
  vpc_id           = "vpc-l4v83ayzkdx4n56c36kru" 
  bandwidth        = 1
  enable_ipsec     = true
  enable_ssl       = false
  payment_type     = "PayAsYouGo" 
}

resource "alicloud_vpn_customer_gateway" "customer_gateway_b" {
  customer_gateway_name = "customer-gw-b" 
  ip_address            = alicloud_vpn_gateway.vpn_gateway_b.internet_ip
  asn                   = 65001
  description           = "Represents VPC B from A"
}

resource "alicloud_vpn_customer_gateway" "customer_gateway_a" {
  customer_gateway_name = "customer-gw-a" 
  ip_address            = alicloud_vpn_gateway.vpn_gateway_a.internet_ip
  asn                   = 65002
  description           = "Represents VPC A from B"
}

resource "alicloud_vpn_connection" "ipsec_connection_a" {
  vpn_connection_name = "ipsec-a-to-b" 
  vpn_gateway_id      = alicloud_vpn_gateway.vpn_gateway_a.id
  customer_gateway_id = alicloud_vpn_customer_gateway.customer_gateway_b.id
  local_subnet        = ["172.40.1.0/24"]
  remote_subnet       = ["192.170.2.0/24"]
  effect_immediately  = true

  ike_config {
    ike_auth_alg = "sha1"
    ike_enc_alg  = "aes"
    ike_version  = "ikev1"
    ike_mode     = "main"
    ike_lifetime = 86400
    psk          = "MySecret123!"
  }

  ipsec_config {
    ipsec_auth_alg = "sha1"
    ipsec_enc_alg  = "aes"
    ipsec_lifetime = 86400
  }
}

resource "alicloud_vpn_connection" "ipsec_connection_b" {
  vpn_connection_name = "ipsec-b-to-a" 
  vpn_gateway_id      = alicloud_vpn_gateway.vpn_gateway_b.id
  customer_gateway_id = alicloud_vpn_customer_gateway.customer_gateway_a.id
  local_subnet        = ["192.170.2.0/24"]
  remote_subnet       = ["172.40.1.0/24"]
  effect_immediately  = true

  ike_config {
    ike_auth_alg = "sha1"
    ike_enc_alg  = "aes"
    ike_version  = "ikev1"
    ike_mode     = "main"
    ike_lifetime = 86400
    psk          = "MySecret123!"
  }

  ipsec_config {
    ipsec_auth_alg = "sha1"
    ipsec_enc_alg  = "aes"
    ipsec_lifetime = 86400
  }
}
*/




/*
#main.tf 1.00
resource "alicloud_vpn_gateway" "vpn_gateway_a" {
  name                  = "vpn-gateway-a"
  vpc_id                = "vpc-l4vtf5uowx1veqr0qytqu"
  bandwidth             = 1
  enable_ipsec          = true
  enable_ssl            = false
  instance_charge_type  = "PostPaid"
}

resource "alicloud_vpn_gateway" "vpn_gateway_b" {
  name                  = "vpn-gateway-b"
  vpc_id                = "vpc-l4v83ayzkdx4n56c36kru"
  bandwidth             = 1
  enable_ipsec          = true
  enable_ssl            = false
  instance_charge_type  = "PostPaid"
}

resource "alicloud_vpn_customer_gateway" "customer_gateway_b" {
  name        = "customer-gw-b"
  ip_address  = alicloud_vpn_gateway.vpn_gateway_b.internet_ip
  asn         = 65001
  description = "Represents VPC B from A"
}

resource "alicloud_vpn_customer_gateway" "customer_gateway_a" {
  name        = "customer-gw-a"
  ip_address  = alicloud_vpn_gateway.vpn_gateway_a.internet_ip
  asn         = 65002
  description = "Represents VPC A from B"
}

resource "alicloud_vpn_connection" "ipsec_connection_a" {
  name                = "ipsec-a-to-b"
  vpn_gateway_id      = alicloud_vpn_gateway.vpn_gateway_a.id
  customer_gateway_id = alicloud_vpn_customer_gateway.customer_gateway_b.id
  local_subnet        = ["172.40.1.0/24"]
  remote_subnet       = ["192.170.2.0/24"]
  effect_immediately  = true

  ike_config {
    ike_auth_alg = "sha1"
    ike_enc_alg  = "aes"
    ike_version  = "ikev1"
    ike_mode     = "main"
    ike_lifetime = 86400
    psk          = "MySecret123!"
  }

  ipsec_config {
    ipsec_auth_alg = "sha1"
    ipsec_enc_alg  = "aes"
    ipsec_lifetime = 86400
  }
}

resource "alicloud_vpn_connection" "ipsec_connection_b" {
  name                = "ipsec-b-to-a"
  vpn_gateway_id      = alicloud_vpn_gateway.vpn_gateway_b.id
  customer_gateway_id = alicloud_vpn_customer_gateway.customer_gateway_a.id
  local_subnet        = ["192.170.2.0/24"]
  remote_subnet       = ["172.40.1.0/24"]
  effect_immediately  = true

  ike_config {
    ike_auth_alg = "sha1"
    ike_enc_alg  = "aes"
    ike_version  = "ikev1"
    ike_mode     = "main"
    ike_lifetime = 86400
    psk          = "MySecret123!"
  }

  ipsec_config {
    ipsec_auth_alg = "sha1"
    ipsec_enc_alg  = "aes"
    ipsec_lifetime = 86400
  }
}



*/


/*
# -------- VPN Gateway for VPC A --------
resource "alicloud_vpn_gateway" "vpn_gateway_a" {
  name       = "vpn-gateway-a"
  vpc_id     = "vpc-l4vtf5uowx1veqr0qytqu"
  spec       = "1Mbps"
  enable_ipsec = true
  enable_ssl   = false
  instance_charge_type = "PostPaid"
}

# -------- VPN Gateway for VPC B --------
resource "alicloud_vpn_gateway" "vpn_gateway_b" {
  name       = "vpn-gateway-b"
  vpc_id     = "vpc-l4v83ayzkdx4n56c36kru"
  spec       = "1Mbps"
  enable_ipsec = true
  enable_ssl   = false
  instance_charge_type = "PostPaid"
}

# -------- Customer Gateway for VPC B (seen from A) --------
resource "alicloud_customer_gateway" "customer_gateway_b" {
  name        = "customer-gw-b"
  ip_address  = alicloud_vpn_gateway.vpn_gateway_b.internet_ip
  asn         = 65001
  description = "Represents VPC B from A"
}

# -------- Customer Gateway for VPC A (seen from B) --------
resource "alicloud_customer_gateway" "customer_gateway_a" {
  name        = "customer-gw-a"
  ip_address  = alicloud_vpn_gateway.vpn_gateway_a.internet_ip
  asn         = 65002
  description = "Represents VPC A from B"
}

# -------- IPsec Connection from A to B --------
resource "alicloud_vpn_connection" "ipsec_connection_a" {
  name                = "ipsec-a-to-b"
  vpn_gateway_id      = alicloud_vpn_gateway.vpn_gateway_a.id
  customer_gateway_id = alicloud_customer_gateway.customer_gateway_b.id
  local_subnet        = ["172.40.1.0/24"] # Subnet of VPC A
  remote_subnet       = ["192.170.2.0/24"]  # Subnet of VPC B
  effect_immediately  = true
  ike_config {
    ike_auth_alg = "sha1"
    ike_enc_alg  = "aes"
    ike_version  = "ikev1"
    ike_mode     = "main"
    ike_lifetime = 86400
    psk          = "MySecret123!" # Use a secure key
  }
  ipsec_config {
    ipsec_auth_alg = "sha1"
    ipsec_enc_alg  = "aes"
    ipsec_lifetime = 86400
  }
}

# -------- IPsec Connection from B to A --------
resource "alicloud_vpn_connection" "ipsec_connection_b" {
  name                = "ipsec-b-to-a"
  vpn_gateway_id      = alicloud_vpn_gateway.vpn_gateway_b.id
  customer_gateway_id = alicloud_customer_gateway.customer_gateway_a.id
  local_subnet        = ["192.170.2.0/24"]  # Subnet of VPC B
  remote_subnet       = ["172.40.1.0/24"] # Subnet of VPC A
  effect_immediately  = true
  ike_config {
    ike_auth_alg = "sha1"
    ike_enc_alg  = "aes"
    ike_version  = "ikev1"
    ike_mode     = "main"
    ike_lifetime = 86400
    psk          = "MySecret123!"
  }
  ipsec_config {
    ipsec_auth_alg = "sha1"
    ipsec_enc_alg  = "aes"
    ipsec_lifetime = 86400
  }
}
*/