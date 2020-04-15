#-------------------------------------------------
# Terraform file
# Build AWS WebServer during bootstrap
# Made by Vova Verholyak
#-------------------------------------------------

provider "aws" {
  region = "eu-central-1"
}

#  створить elastic ip, привяже до instance
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id  
}

resource "aws_instance" "my_webserver" {
  ami               = "ami-0ba441bdd9e494102"
  instance_type     = "t2.micro"
  key_name          = "aws-terraform-github"
  source_dest_check = false

  tags = {
    Name = "WebServer-Terraform"
  }
 
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("user-data.sh")
  
# перед тим як вбити сервер, створить новий а потім вбє  
  lifecycle {
    create_before_destroy = true
  }
  
# --------------------------------
#  lifecycle {
#    prevent_destroy = true  # не дає знищити сервер ! або ->
#    ignore_changes = ["ami", "key_name" "user_data"]  # ігнорить зміни !
#  }
# --------------------------------  
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Security Group for zabbix monitoring"

  tags = {
    Name = "Web Server Security Group Terraform"
  }
  
  dynamic "ingress" {
    for_each = ["80", "443", "10050"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
