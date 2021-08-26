# 10_security_identity_&_compliance

The task is to create a new user, attach to this account some policies, create a Role that could be assumed by the newly created user to use in AWS CLI as a temporary access.

### Pre-requisites:
- Already created S3 bucket
- Installed jq - https://stedolan.github.io/jq/download/ 
- Installed AWS cli v1 - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html
- https://awspolicygen.s3.amazonaws.com/policygen.html or https://aws.amazon.com/blogs/security/use-the-new-visual-editor-to-create-and-modify-your-aws-iam-policies/ 

### User and Role

 - Create a new user. 
 - Attach to the new user AWS managed policy: **S3 full access**. 
 - Attach to the new user an inline policy, that should contain the follow “Actions”:
    - **ssm:ReadOnly** 
    - **kms:Decrypt** 
    - **iam:ListRoles** 
    - **sts:AssumeRole** 

- Attach to the new user the Customer managed policy named “KmsDecryptPolicy”, that policy should contain “Action”: **kms:Decrypt**

- After attaching all of that policies to the new user, add him permission for programmatic api access 
- Add Role named “S3ReadOnlyRole”, attach to the role AWS managed policy: **S3 read-only**

- Create a json and assume role policy that defines the trust relationship of the IAM role: 

```
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": { "AWS": "arn:aws:iam::123456789012:user/new_created_user" },
        "Action": "sts:AssumeRole"
    }
}
```

## Used resources

terraform modules from https://github.com/SebastianUA/terraform.git

Great thanks to Vitaliy Natarov!

## AWS CREDENTIALS

```
aws configure
```

## Terrfaorm

```
terraform init
terrafrom plan
terrafrom apply
terraform destroy
```

## Verification:

1. credentials retrieval from AWS CLI for the newly created user 
```
terraform show -json | jq '.values.outputs | [.aws_iam_id.value, .aws_iam_secret.value]'
```

2. authorize in AWS CLI using credentials from the previous step 
```
export AWS_ACCESS_KEY_ID=someaccesskey
export AWS_SECRET_ACCESS_KEY=somesecretkey

aws sts get-caller-identity | jq -r

aws s3 ls
```

3. write file to an existing s3 bucket to test full access using AWS CLI 
```
aws s3 cp additional_files/CustomerPolicy.json  s3://epam-leodorov-s3-learning10/additional_files/CustomerPolicy.json
```

4. perform role assuming using command `aws sts assume-role`
```
aws iam list-roles --query "Roles[?RoleName == 'S3ReadOnlyRole'].[RoleName, Arn]" | jq -r

aws sts assume-role --role-arn "arn:aws:iam::123456789012:role/S3ReadOnlyRole" --role-session-name AWSCLI-Session
```

5. authorize in AWS CLI using credentials from the previous step 
```
export AWS_ACCESS_KEY_ID=someaccesskey
export AWS_SECRET_ACCESS_KEY="somesecretkey"
export AWS_SESSION_TOKEN="somesessiontoken"
```

6. make sure that you are authorized by using role 
```
aws sts get-caller-identity | jq -r
```

7. make a try to write file from step 2 
```
aws s3 cp additional_files/user_policy.json  s3://epam-leodorov-s3-learning10/additional_files/user_policy.json
```

8. copy file from s3, that was uploaded in step, using AWS CLI 
```
aws s3 cp s3://epam-leodorov-s3-learning10/additional_files/CustomerPolicy.json /tmp/CustomerPolicy.json
```
