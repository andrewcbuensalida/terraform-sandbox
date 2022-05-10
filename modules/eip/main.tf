resource "aws_s3_bucket" "mybucket" {
  bucket = "provider-inherit-example"
}


resource "aws_eip" "myeip" {
  instance = path.module
}