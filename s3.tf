module "s3_private_bucket" {
  source      = "../../modules/s3"
  name        = "epam-leodorov-s3-learning10"
  environment = "learning"

  # AWS S3 bucket
  enable_s3_bucket = true
  s3_bucket_name   = "epam-leodorov-s3-learning10"
  s3_bucket_acl    = "private"

  enable_s3_bucket_policy = false

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "iam"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

}