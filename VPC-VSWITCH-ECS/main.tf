# -----------------------------
# VPC CONFIGURATION
# -----------------------------

# Create a VPC with a CIDR block
resource "alicloud_vpc" "main_vpc" {
  vpc_name   = "TerraformVPC"         # Name of the VPC
  cidr_block = "192.168.0.0/16"       # IP range for the VPC
}

# -----------------------------
# VSWITCH CONFIGURATION
# -----------------------------

# Create a VSwitch in Zone A
resource "alicloud_vswitch" "vsw_a" {
  vswitch_name = "Terraform-vswitch-zone-a"  # Name of the VSwitch
  cidr_block   = "192.168.1.0/24"            # Subnet range for Zone A
  vpc_id       = alicloud_vpc.main_vpc.id    # Link to the VPC
  zone_id      = "cn-hangzhou-i"             # Replace with actual Zone A ID
}

# Create a VSwitch in Zone B
resource "alicloud_vswitch" "vsw_b" {
  vswitch_name = "Terraform-vswitch-zone-b"  # Name of the VSwitch
  cidr_block   = "192.168.2.0/24"            # Subnet range for Zone B
  vpc_id       = alicloud_vpc.main_vpc.id    # Link to the VPC
  zone_id      = "cn-hangzhou-j"             # Replace with actual Zone B ID
}

# -----------------------------
# SECURITY GROUP CONFIGURATION
# -----------------------------

# Create a security group inside the VPC
resource "alicloud_security_group" "ecs_sg" {
  security_group_name = "Terraform-ecs-sg"   # Name of the security group
  vpc_id              = alicloud_vpc.main_vpc.id
}

# Allow incoming SSH connections on port 22
resource "alicloud_security_group_rule" "allow_ssh" {
  type              = "ingress"                       # Inbound rule
  ip_protocol       = "tcp"                           # TCP protocol
  port_range        = "22/22"                         # Only port 22
  priority          = 1
  security_group_id = alicloud_security_group.ecs_sg.id
  cidr_ip           = "0.0.0.0/0"                     # Open to all (not recommended for production)
}

# -----------------------------
# ECS INSTANCE CONFIGURATION
# -----------------------------

# Launch an ECS instance in Zone A
resource "alicloud_instance" "ubuntu_instance" {
  availability_zone           = "cn-hangzhou-i"           # Deploy in Zone A
  instance_name               = "ubuntu-instance"         # Name of the instance
  image_id                    = "ubuntu_22_04_x64_20G_alibase_20240118.vhd"  # Ubuntu 22.04 image
  instance_type               = "ecs.t6-c1m1.large"        # Adjust based on availability
  vswitch_id                  = alicloud_vswitch.vsw_a.id # Attach to VSwitch A
  security_groups             = [alicloud_security_group.ecs_sg.id]

  # Access credentials
  password                    = "Root"       # Instance login password (not secure!)
  key_name                    = "testSSH"    # SSH Key Pair name that already exists in Alibaba Cloud

  # Network configuration
  internet_max_bandwidth_out = 10           # 10 Mbps outbound internet bandwidth

  # Disk configuration
  system_disk_category = "cloud_efficiency" # Disk type
  system_disk_size     = 40                 # 40 GB system disk
}
