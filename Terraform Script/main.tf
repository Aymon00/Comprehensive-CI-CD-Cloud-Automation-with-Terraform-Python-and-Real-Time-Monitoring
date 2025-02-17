# Configure the AWS Provider

provider "aws" {
  region  = "us-east-1"
  profile = "justuser"
}

# 1- Define the VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = var.vpc_name
    Environment = "project2_environment"
    Terraform   = "true"
  }
}

# 2A- Getting the list of the available AZs in our region
data "aws_availability_zones" "available_zones" {
  state = "available"
}

# 2B - Create the Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  tags = {
    Name      = "project_public_subnet"
    Terraform = "true"
  }
}

#3 - Create the Internet Gateway and attach it to the VPC using a Route Table
# 3A - Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "project_igw"
  }
}
# 3B - Create route table for the public subnet and associate it with the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name      = "project_public_rtb"
    Terraform = "true"
  }
}
#3C- Create route table associations to the public subnet
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnet]
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

#4- Create a Security Group for the EC2 Instance
resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins_sg"
  vpc_id = aws_vpc.vpc.id
  # Since Jenkins runs on port 8080, we are allowing all traffic from the internet
  # to be able ot access the EC2 instance on port 8080
  ingress {
    description = "Allow all traffic through port 8080"
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Since we only want to be able to SSH into the Jenkins EC2 instance, we are only
  # allowing traffic from our IP on port 22
  ingress {
    description = "Allow SSH from my computer"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }
  # We want the Jenkins EC2 instance to being able to talk to the internet
  egress {
    description = "Allow all outbound traffic"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # We are setting the Name tag to tutorial_jenkins_sg
  tags = {
    Name = "tutorial_jenkins_sg"
  }
}
# 5- Create the Jenkins EC2 instance, add the Jenkins installation to its user data and attach to it Elastic IP.
#5A- Create the Key Local and attach to the instance.
resource "aws_key_pair" "MyKey_SSH" {
  key_name   = "MyKey"
  public_key = file("~/.ssh/MyKey.pub")
}
# 5B- This data store is holding the most recent ubuntu 20.04 image
data "aws_ami" "ubuntu" {
  most_recent = "true"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

#5C- Create the EC2 Instance 
resource "aws_instance" "jenkins_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "MyKey"
  availability_zone      = data.aws_availability_zones.available_zones.names[0]
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id              = aws_subnet.public_subnet.id
  root_block_device {
    encrypted = true
  }
  user_data = file("${path.module}/jenkins_installation.sh")
  tags = {
    Name = "Jenkins_Instance"
  }
}

#5D- Creating an Elastic IP called jenkins_eip
resource "aws_eip" "jenkins_eip" {
  # Attaching it to the jenkins_server EC2 instance
  instance = aws_instance.jenkins_instance.id

  # Making sure it is inside the VPC
  vpc = true

  # Setting the tag Name to jenkins_eip
  tags = {
    Name = "jenkins_eip"
  }
}
