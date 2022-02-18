provider "aws" {
  region     = "us-east-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
resource "aws_s3_bucket" "ec2_bucket" {
  bucket = "sirri-ec2-bucket"
  acl    = "private"
  versioning {
         enabled = true
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.ec2_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["861257366984"] 
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.ec2_bucket.arn,
      "${aws_s3_bucket.ec2_bucket.arn}/*",
    ]
  }
}
