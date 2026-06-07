# Minecraft Server Using Terraform

## Background

This project automates the deployment process of a Minecraft Java Edition AWS server using Terraform and shell scripting.

It uses Terraform to create the AWS infrastructure. This includes the setup of the EC2 instance and security group. Once the instance is created, a setup script will be used to automatically install Java, download the Minecraft server software, and configure the systemd service. Then it will start the server.

## Requirements

### Configurations needed

Before this deployment pipeline will function, the following is needed:
- An active AWS or AWS Academy Learner Lab account.
    * Along with valid credentials.
- An existing AWS EC2 Key Pair.
    * The matching pair will need to be stored locally.

The private key will need to be stored in:
```txt
~/.ssh/<name of key>.pem
```
To guarantee it has the correct permissions, run
```bash
chmod 400 ~/.ssh/<name of key>.pem
```
**Note:** Change ``<name of key>`` to whatever you named your key. In the files the key file is named MyLinuxKey.pem.

### Tools to install

Tools to install include:
1. Terraform (Version: >= 1.15.5)
    ```bash
    sudo apt install -y gnupg software-properties-common

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update

    sudo apt install -y terraform

    terraform version
    ```
2. AWS CLI (Version: >= 2.34.53 Python, >= 3.14.5 Linux)
    ```bash
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

    unzip awscliv2.zip

    sudo ./aws/install

    aws --version
    ```
3. Nmap (Version: >= 7.94)
    ```bash
    sudo apt install -y nmap

    nmap --version
    ```
4. Git (Version: >= 2.43.0)
    ```bash
    sudo apt install -y git

    git --version
    ```

### AWS Credentials for CLI use

To access the AWS CLI credentials from AWS Academy Learner Lab. First you must:

1. Open AWS Academy Learner Lab.
2. Start your lab environment.
3. Select the ``AWS Details`` button.
4. Copy the credentials:
    - AWS Access Key ID
    - AWS Secret Access Key
    - AWS Session Token
- Your AWS Region can also be found here if you are unsure of your region.

Once obtained, the AWS CLI can be configured using:

```bash
aws configure
```

It will prompt you for the:

```txt
AWS Access Key ID
AWS Secret Access Key
AWS Session Token
Default Region
Default Output Format
```

Supply each prompt with the credentials you obtained. The repository code has the region set to ``us-east-1``. The standard output format is ``json``.

**Note:** With AWS Academy Learner Lab you must make sure the credentials are current. They change every few hours. If not current, AWS will deny access and AWS will need to be re-configured.

### Environmental variables

Due to the use of ``aws configure``, environmental variables such as:

```bash
export AWS_ACCESS_KEY_ID=<access-key>
export AWS_SECRET_ACCESS_KEY=<secret-key>
export AWS_SESSION_TOKEN=<session-token>
export AWS_DEFAULT_REGION=us-east-1
```

Are not needed to supply the AWS credentials.

## Diagram

The repository structure is as follows:

```txt
README.md
terraform
  |-- main.tf
  |-- outputs.tf
  |-- provider.tf
  |-- setup.sh
  |-- terraform.tfvars
  |-- variables.tf
```

The pipeline steps are as follows:

```txt
User
  ↓
terraform apply
  ↓
Create security group
  ↓
Create EC2 Instance
  ↓
Upload setup.sh
  ↓
Run setup.sh
  |⟶ Install Java
  |⟶ Download Minecraft Server Software
  |⟶ Accept EULA
  |⟶ Configure systemd service
  |⟶ Start Minecraft server
  ↓
Running Minecraft Server
```

## List of Commands

The first thing to do is clone this repository:

```bash
git clone https://github.com/joel-rg/CS312_Project_Part_2.git
```

The next step is to initialize Terraform:

```bash
terraform init
```

The Terraform configuration can be validated with:

```bash
terraform validate
```

This command can be used to preview Terraform resources that will be created:

```bash
terraform plan
```

Finally, the plan can be applied using:

```bash
terraform apply
```

When prompted, enter: ``yes``

After finishing, it will say "``Apply complete!``" and below will appear:

```txt
Outputs:

public_ip = "<public-ip>"
```
This public IP will be needed in order to connect to the server.

## How to connect to server

Once the server is running, it can be verified with:

```bash
nmap -sV -Pn -p T:25565 <supplied public-ip>
```

The expected output will be:

```txt
PORT      STATE SERVICE   VERSION
25565/tcp open  minecraft Minecraft 26.1.2 (Protocol: 127, Message: A Minecraft Server, Users: 0/20)
```

To connect through Minecraft java Edition you need to:

1. Provide a server name
2. Enter: ``<public-ip>:25565``
3. Join the server

### Cleanup

When finished, destroy AWS resources to prevent incurring costs.

This can be done with the following:

```bash
terraform destroy
```

When prompted, enter: ``yes``

## Resources

- [Minecraft Java Server Download](https://www.minecraft.net/en-us/download/server)
- [systemd Documentation](https://systemd.io/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Minecraft/Terraform Guide 1](https://blog.abstractlabs.co.uk/how-to-deploy-a-minecraft-server-on-aws-using-terraform-iac-b8691e87b55f)
- [Minecraft/Terraform Guide 2](https://www.endpointdev.com/blog/2020/07/automating-minecraft-server/)
- [Github Example 1](https://github.com/dimmaski/terraform-aws-minecraft-server/tree/master/terraform)
- [Github Example 2](https://github.com/darrelldavis/terraform-aws-minecraft)
