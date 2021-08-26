module "iam_policy" {
  source      = "../../modules/iam_policy"
  name        = "epam-leodorov-iam"
  environment = "learning"

  # Using IAM policy
  enable_iam_policy = true
  iam_policy_name   = "KmsDecryptPolicy"
  iam_policy_path   = "/"
  iam_policy_policy = file("additional_files/CustomerPolicy.json")

  enable_iam_policy_attachment  = true
  iam_policy_attachment_users   = [module.iam_user_10.iam_user_name]

  depends_on = [
    module.iam_user_10
  ]

}