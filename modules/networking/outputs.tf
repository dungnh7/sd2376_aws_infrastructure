output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [aws_subnet.private-ap-southeast-1a.id, aws_subnet.private-ap-southeast-1b.id, 
           aws_subnet.public-ap-southeast-1a.id, aws_subnet.public-ap-southeast-1b.id]
}

output "public_subnet_ids" {
  value = [aws_subnet.public-ap-southeast-1a.id, aws_subnet.public-ap-southeast-1b.id]
}

output "security_group_id" {
  value = aws_security_group.allow_ssh_http.id
}