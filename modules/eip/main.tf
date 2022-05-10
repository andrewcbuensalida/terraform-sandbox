resource "aws_eip" "myeip" {
  instance = var.instanceID
  
}