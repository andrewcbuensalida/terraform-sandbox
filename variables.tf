variable "availability_zone_name" {
  type    = string
  # if it is not assigned via env variables in cloud, or command line option, or .tfvars file, it will be assigned the default
  default = "us-west-1a"

}
