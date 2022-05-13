terraform {
  # just need to log in through cli and have this in order to upload to terraform cloud
  cloud {
    organization = "andrews-sandbox"
    workspaces {
      name = "terraform-sandbox"
    }
  }
  # so terraform knows what .exe to download from the registry
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
# each provider must be declared in the required providers section above
provider "aws" {
  # profile = "default" //for straight cli method, wont work with tf cloud workflow. default pulls the credentials from aws-cli. with cloud workflow, comment this out because it gets the access_key and secret_key from the variables you set in cloud.
  region = "us-west-1"

}



# linked to ami in terraform.tfvars. this block can be put in variables.tf
variable "ami" {
  type = string
}

# resources are to create/modify infrastructure
resource "aws_instance" "mySandboxInstance" {
  # could be hard-coded "ami-01f87c43e618bf8f0" or through a variable from above block
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.ec2-key-pair-mySandboxInstance.key_name
  # key_name = "ec2"
  # var.availability_zo.... is defined from variables.tf, but is assigned from env variables in cloud, or command line option, or .tfvars
  availability_zone = var.availability_zone_name
  security_groups   = ["default"]
  # to install code pipeline in the ec2
  user_data = <<-EOF
              #!/bin/bash
              sudo apt -y update
              sudo apt -y install ruby
              sudo apt -y install wget
              cd /home/ubuntu
              wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
              sudo chmod +x ./install
              sudo ./install auto
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
              . ~/.nvm/nvm.sh
              nvm install node


              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your very first web server > /var/www/html/index.html'
              EOF

  tags = {
    Name = "mySandboxInstance"
  }
}



# this is to create a new key pair, but should already have .pem
# resource "aws_key_pair" "ec2-key-pair-mySandboxInstance" {
#   key_name   = "ec2-key-pair-mySandboxInstance"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu1w50qkgocp5k2KPoi84/Kp2FRJ960ZPDyeSoiEskWD64ZuyXacvp4t8O6Rc/pr1xrUZjrbQtwSsJ/6Z1dN/JF4KVJSAuJwWXu7iZtYnDZ13pVpu8nI5R45NfVET52O2refvJoOgWE6T6npui6Ow85IDywPj4klMDVTbmUNj4wty4hV7RrzNj/0zi9SJ76xITvSOnGOzAPtcT+zOrrRbpnyUbPGXrdDzPau1D/K4FQe2Sam6NDxV4KpC7Cq4Y1p01JsTGcXgGwcNav2Dx6sZmgYykHpfi2x36sJ1BW87AM9bfhEEKgvRCJWik1tHC3GdGORcajzAZgAHmKpPt4IdN imported-openssh-key"
# }

# data is for reads, and in this case, is used to get an existing key pair. the aws in aws_key_pair is the provider, the key_pair is the type of resource, ec2-key-pair-mySandboxInstance is a custom name used only in these files. or could just put string "ec2" in key_name in instance resource
data "aws_key_pair" "ec2-key-pair-mySandboxInstance" {
  # these are the search arguments
  key_name = "ec2"
  filter {
    name   = "tag:portfolio"
    values = ["1"]
  }
}

# to hook up a file
module "eip" {
  source     = "./modules/eip"
  instanceID = aws_instance.mySandboxInstance.id
  count = var.include_eip ? 1 : 0
  
}

module "website_s3_bucket" {
  # source can also be from private module registry, first have to make a release on github, then hook it up to terraform registry
  source = "./modules/aws-s3-static-website-bucket"

  # this becomes a variable in the child module
  bucket_name = "andrewsbucket-${uuid()}"

  tags = {
    Terraform = "true"
    # notice we remove the s in locals
    Environment = local.environment
  }
}

locals {
  environment = "dev"
}

