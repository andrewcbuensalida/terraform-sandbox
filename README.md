https://www.youtube.com/watch?v=SLB_c_ayRMo&t=2717s

for terraform cloud
https://learn.hashicorp.com/tutorials/terraform/aws-remote?in=terraform/aws-get-started


workflow: just push or pr to remote master in gh, terraform cloud should detect changes then auto apply.

the other workflow is, 
    terraform apply
on local, then it will update terraform cloud, but have to setup cloud to do it this way. cant have github workflow and local cli workflow at the same time.

for the first time auto deploying from gh to tf cloud, have to do it manually.

/////////////////////////////////////////

Having an error when ssh

At least it created the instance this time, but then it also created a new key pair.

ssh -i "ec2.pem" ubuntu@ec2-54-151-8-143.us-west-1.compute.amazonaws.com
Error says connection time out. Can't connect through aws console either. 
So I manually edited inbound rules of the security group to allow ssh, http, and https.
Now in command line I can connect via ssh. Can also connect via console connect.
