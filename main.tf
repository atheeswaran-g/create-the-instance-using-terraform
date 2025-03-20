provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "web" {
  ami           = "ami-09a9858973b288bdd"
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

resource "tls_private_key" "rsa-4096-example"{
  algorithm="RSA"
  rsa_bits=4096
}

resource "aws_key_pair" "my_key_pair"{
  key_name="my-key"
  public_key=tls_private_key.rsa-4096-example.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "deployer-key.pem"
  content  = tls_private_key.rsa-4096-example.private_key_pem
  file_permission = "0600"  
}