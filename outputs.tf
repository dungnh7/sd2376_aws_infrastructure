output "jenkins_public_ip" {
  value = module.jenkins.public_ip
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}