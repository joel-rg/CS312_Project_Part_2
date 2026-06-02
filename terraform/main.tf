# Creates a security group for the AWS instance.
resource "aws_security_group" "minecraft_sg" {
	# Security group name.
	name = "minecraft-server-sg"

	# Allow incoming traffic from anywhere.
	ingress {
		from_port = 25565
		to_port = 25565
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Allow incoming SSH from anywhere.
	ingress {
		from_port =  22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Allow all outbound traffic.
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# Create the AWS instance.
resource "aws_instance" "minecraft" {
	# Sets up AMI, instance size, key and security group.
	ami = "ami-04a81a99f5ec58529"
	instance_type = var.instance_type
	key_name = var.key_name
	vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

	# Tag for instance identification in AWS.
	tags = {
		Name = "MinecraftServer"
	}

	# Sends the script to the AWS instance.
	provisioner "file" {
		source = "setup.sh"
		destination = "/tmp/setup.sh"

		# Sets up the ssh connection.
		connection {
			type = "ssh"
			user = "ubuntu"
			private_key = file("~/.ssh/MyLinuxKey.pem")
			host = self.public_ip
		}
	}

	# Activates the script on the AWS instance.
	provisioner "remote-exec" {
		# Runs the setup script.
		inline = [
			"chmod +x /tmp/setup.sh",
			"sudo /tmp/setup.sh"
		]

		# Sets up the ssh connection.
		connection {
			type = "ssh"
			user = "ubuntu"
			private_key = file("~/.ssh/MyLinuxKey.pem")
			host = self.public_ip
		}
	}
}
