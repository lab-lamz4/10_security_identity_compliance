module "iam_role" {
  source      = "../../modules/iam_role"
  name        = "epam-leodorov-iam"
  environment = "learning"

  # Using IAM role
  enable_iam_role      = true
  iam_role_name        = "S3ReadOnlyRole"
  iam_role_description = "Role to be assigned for temporary access"
  iam_role_assume_role_policy = templatefile("additional_files/assume_role_policy.json", { user_arn = module.iam_user_10.iam_user_arn})

  iam_role_force_detach_policies = true
  iam_role_path                  = "/"
  iam_role_max_session_duration  = 3600

  # Using IAM role policy
  enable_iam_role_policy = false

  # Using IAM role policy attachment
  enable_iam_role_policy_attachment      = true
  iam_role_policy_attachment_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "iam"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

  depends_on = [
    module.iam_user_10
  ]
}
