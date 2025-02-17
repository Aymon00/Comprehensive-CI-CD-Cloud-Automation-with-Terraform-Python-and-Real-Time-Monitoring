output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}
output "sg_id" {
  description = "The ID of the security group"
  value       = aws_security_group.jenkins_sg.id
}
output "Jenkins_server_public_ip" {
  description = "The public IP address of the Jenkins server"
  value       = aws_eip.jenkins_eip.public_ip
}
