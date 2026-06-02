# Supplies terraform with the needed provider (plugin for AWS).
terraform {
	required_providers {
		# Required AWS provider plugin and version.
		aws = {
			source = "hashicorp/aws"
			version = "~> 5.0"
		}
	}
}
# Configuration needed for the AWS provider.
provider "aws" {
	region = var.aws_region
}
