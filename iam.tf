### DEV ACCOUNT ###

resource "aws_iam_role" "dev_list_s3" {
  name = "s3-list-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "arn:aws:iam::${data.aws_caller_identity.playground.account_id}:root" }
    }]
  })
  provider = aws.dev
}

resource "aws_iam_policy" "s3_list_all" {
  name        = "s3_list_all"
  description = "allows listing all s3 buckets"
  policy      = file("role_permissions_policy.json")

  provider = aws.dev
}

resource "aws_iam_policy_attachment" "s3_list_all" {
  name       = "list s3 buckets policy to role"
  roles      = ["${aws_iam_role.dev_list_s3.name}"]
  policy_arn = aws_iam_policy.s3_list_all.arn
  provider   = aws.dev
}

### PLAYGROUND ACCOUNT ###
resource "aws_iam_user" "random" {
  name = "random_user"

  tags = {
    name = "random"
  }
}

resource "aws_iam_policy" "dev_s3" {
  name        = "dev_s3"
  description = "allow assuming dev_s3 role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::${data.aws_caller_identity.dev.account_id}:role/${aws_iam_role.dev_list_s3.name}"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "dev_s3" {
  user       = aws_iam_user.random.name
  policy_arn = aws_iam_policy.dev_s3.arn
}
