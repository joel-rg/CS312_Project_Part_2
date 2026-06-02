# Variable for the AWS region.
variable "aws_region" {
	default = "us-east-1"
}
# Variable for the AWS instance type.
variable "instance_type" {
	default = "t2.micro"
}
# Variable for AWS key description.
variable "key_name" {
	description = "AWS key pair name"
}
