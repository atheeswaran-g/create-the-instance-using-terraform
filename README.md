# create-the-instance-using-terraform
    Step 1: Install Terraform
      If you haven't installed Terraform yet, download it from Terraform's official       website.
      After installation, verify Terraform using:

        "terraform -version"

    
    Step 2: Create a Terraform Configuration File:
      Create a new directory for your Terraform project:

            "mkdir terraform-ec2 && cd terraform-ec2"

    Step 3: Write Terraform Code (main.tf)
      Open main.tf and add the following configuration:
      Explanation:
        provider "aws" → Specifies AWS as the cloud provider and sets the region.
        resource "aws_instance" → Defines an EC2 instance.
        ami → Amazon Machine Image (AMI) ID for Amazon Linux 2 (change based on             your region).
        instance_type → Defines the instance size (t2.micro is free-tier eligible).
        tags → Adds a name tag to the instance.

    Step 4: Initialize Terraform
      Run the following command to initialize Terraform (downloads necessary AWS          plugins):
                "terraform init"

    Step 5: Plan the Terraform Deployment
      Before creating the instance, check what Terraform will do:

            "terraform plan"
    Step 6: Apply the Configuration (Create EC2)
      Deploy the EC2 instance by running:

        "terraform apply"
    Step 7:Destroy the EC2 Instance (If Needed)
      If you want to delete the EC2 instance later, run:

          "terraform destroy"


# Create a New Key Pair
    1️⃣ Define the AWS Provider:

        provider "aws" {
          region = "us-east-1"  # Change this to your preferred AWS region
        }

    2️⃣ Create a New Key Pair
      This will generate a new key pair and save the private key to a local file          (my-key.pem).

          resource "tls_private_key" "my_key" {
            algorithm = "RSA"
            rsa_bits  = 2048
          }

        resource "aws_key_pair" "my_key" {
          key_name   = "my-terraform-key"
          public_key = tls_private_key.my_key.public_key_openssh
        }

      resource "local_file" "private_key" {
        content  = tls_private_key.my_key.private_key_pem
        filename = "${path.module}/my-key.pem"
      }

      🔹 Explanation:
          > tls_private_key: Generates a new RSA key pair.
          > aws_key_pair: Creates an AWS key pair using the generated public key.
          > local_file: Saves the private key to my-key.pem in your Terraform directory.
  
# create a Security Group
    3️⃣ Create a Security Group
        This security group will: ✅ Allow SSH (port 22) from anywhere.
        ✅ Allow HTTP (port 80) & HTTPS (port 443) for web servers.

        resource "aws_security_group" "my_sg" {
          name        = "my-security-group"
          description = "Allow SSH and HTTP/S traffic"

          ingress {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from any IP
        }

          ingress {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access
      }

        ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS access
    }

        egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
      }
    }

      -----------------------------------------------------------------------

