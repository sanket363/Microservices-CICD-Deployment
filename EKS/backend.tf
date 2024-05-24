terraform {
 backend "s3" {
   bucket = "terraform-backend-bucket-sanket"
   key    = "eks/terraform.tfstate"
   region = "us-east-1"
 }
}
