# Variable that will be displayed as output after terraform plan is applied.
output "public_ip" {
	value = aws_instance.minecraft.public_ip
}
