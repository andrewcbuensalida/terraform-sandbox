output "eip-address" {
  value = aws_eip.myeip.address
}

output "eip-public-ip" {
  value = aws_eip.myeip.public_ip
}