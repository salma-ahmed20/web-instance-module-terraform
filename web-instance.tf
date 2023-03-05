#create web instance resource
resource "aws_instance" "my-ec2"{
    ami="ami-0c0933ae5caf0f5f9"
    instance_type="t2.micro"
    vpc_security_group_ids = [aws_security_group.web-sg.id]
    # for_each = var.public_subnet_id
    subnet_id      = var.public_subnet_id
    tags = {
        Name = "web-instance"
    }
}

#creatte elastic ip
resource  "aws_eip" "my-eip"{
    vpc = true
}

#associate elastic ip to web instance
resource "aws_eip_association" "associate"{
    instance_id=aws_instance.my-ec2.id
    allocation_id=aws_eip.my-eip.id

}

#create security group for web instance
resource "aws_security_group" "web-sg" {
  name = "terraform-sg-web"
  vpc_id = var.vpc_id
  tags = {
    Name = "test-sg"
    type = "terraform-test-security-group"
  }

  ingress {
    description      = "Https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}
