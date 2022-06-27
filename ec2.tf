resource "aws_instance" "myec2" {
  ami                    = "ami-05ba3a39a75be1ec4"
  instance_type          = "t2.medium"
  availability_zone      = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = "ubuntu-keypair"
  tags = {
    name = "minikube_instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && apt -y install docker.io",
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl &&   chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl",
      "wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "sudo cp minikube-linux-amd64 /usr/local/bin/minikube",
      "sudo chmod 755 /usr/local/bin/minikube",
      "sudo apt install conntrack",
      "sudo minikube start --vm-driver=none"
      "sudo minikube status"
      "sudo chmod +x /home/ubuntu/kubectl",
      "sudo cp kubectl /usr/local/bin/kubectl",
      "sudo usermod -aG docker ubuntu"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/root/ubuntu-keypair.pem")
    }
  }
}
