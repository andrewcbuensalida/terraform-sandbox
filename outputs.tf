output "instanceID" {
  value = aws_instance.mySandboxInstance.id
}

output "bucketName" {
  # comes from child module
  value = module.website_s3_bucket.name
}

output "eip-public-ip" {
  # * means splat, means all elements in the list, because module eip has count attribute, it becomes a list. one gets the element if it is a list of one, null if it is an empty list, error if it is more than one.
  value = one(module.eip[*].eip-public-ip)
}