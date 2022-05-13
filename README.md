https://www.youtube.com/watch?v=SLB_c_ayRMo&t=2717s

for terraform cloud
https://learn.hashicorp.com/tutorials/terraform/aws-remote?in=terraform/aws-get-started


workflow: just push or pr to remote master in gh, terraform cloud should detect changes then auto apply. (if using the vcs to cloud method. the other method is cli to cloud. another method is straight cli (no cloud) method)

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

///////////////////////////////////

it's not all or nothing. if some resources fail, it won't stop other resources.

//////////////////////////////////
.terraform folder is auto-generated after apply? or plan? or init?

/////////////////////////////////////
terraform.tfvars only works for root module, not child module. have to get variables from the parent.

////////////////////////////////////////
only root output will be display when running apply.
the use of the output in a child module is so the parent could access data with module.<child module>...
sibling modules cant access outputs directly

/////////////////////////////////////////
there's two ways of splitting prod from dev
1. have them in separate folders
2. difference workspaces

///////////////////////////////////
when rearranging modules or renaming, by default, terraform will destroy and recreate the resource. if you dont want that to happen, put it in a moved block.


//////////////////
if the resource has count, the output is a list
if the resource has for_each, the output is an object


//////////////////
terraform fmt -recursive
is like prettier