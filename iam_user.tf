# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# iam users
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module "iam_user_10" {
  source      = "../../modules/iam_user"
  name        = "epam-leodorov-iam"
  environment = "learning"

  # Using IAM user
  enable_iam_user        = true
  iam_user_name          = "s3-learning-user-10"
  iam_user_path          = "/"
  iam_user_force_destroy = true

  enable_iam_user_policy = true
  iam_user_policy_name   = "user-policy-learning10-s3full"
  iam_user_policy_policy = file("additional_files/user_policy.json")

  enable_iam_user_policy_attachment     = true
  iam_user_policy_attachment_policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

  enable_iam_user_ssh_key           = false
  enable_iam_user_group_membership  = false
  enable_iam_user_login_profile     = false
  
  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "iam"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
}

resource "aws_iam_access_key" "user" {
  user = module.iam_user_10.iam_user_name
}
