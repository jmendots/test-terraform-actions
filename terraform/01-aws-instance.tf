resource "aws_instance" "example" {
  ami = "ami-06ad2ef8cd7012912"
  instance_type = "t2.micro"
}