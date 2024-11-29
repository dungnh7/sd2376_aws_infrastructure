resource "aws_instance" "jenkins_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              # Update and install dependencies
              sudo apt-get update
              sudo apt-get install -y ca-certificates curl gnupg lsb-release

              # Install Docker
              sudo install -m 0755 -d /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              sudo chmod a+r /etc/apt/keyrings/docker.gpg
              echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
              sudo usermod -aG docker ubuntu

              # Install Java
              sudo apt-get install -y openjdk-11-jdk

              # Install Jenkins
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
                /usr/share/keyrings/jenkins-keyring.asc > /dev/null
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update
              sudo apt-get install -y jenkins

              # Start Jenkins
              sudo systemctl enable jenkins
              sudo systemctl start jenkins

              # Install additional tools
              sudo apt-get install -y git

              #open port
              sudo apt update
              sudo apt install ufw
              sudo ufw allow 8080
              sudo ufw allow OpenSSH
              sudo ufw enable

              # Print Jenkins initial admin password
              echo "Jenkins initial admin password:"
              sudo cat /var/lib/jenkins/secrets/initialAdminPassword

              #end for jenkins

              #fix issue docker
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              sudo apt install unzip
              unzip awscliv2.zip
              sudo ./aws/install

              #setup kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
              chmod +x kubectl
              mkdir -p ~/.local/bin
              mv ./kubectl ~/.local/bin/kubectl

              #Fix docker
              sudo chmod 666 /var/run/docker.sock

              #setup helm
              sudo rm -rf /usr/local/bin/helm
              sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
              EOF

  tags = {
    Name = "JenkinsServer"
  }
}

resource "aws_security_group_rule" "allow_jenkins" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] // for dev test learning
  security_group_id = var.security_group_id
}
