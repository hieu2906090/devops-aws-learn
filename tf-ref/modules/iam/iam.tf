/////////////////////get iam ///////////////
data "aws_caller_identity" "current" {}

locals {
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

data "aws_iam_policy_document" "policy_doc" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${var.s3_bucket_arn}"]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${var.s3_bucket_arn}/*"]
  }

  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = ["${var.dynamodb_arn}"]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "${title(var.environment)}S3BackendPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.policy_doc.json
}

resource "aws_iam_role" "iam_role" {
  name = "${title(var.environment)}S3BackendRole"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
        "AWS": ${jsonencode(local.principal_arns)}
      },
      "Effect": "Allow"
      }
    ]
  }
  EOF

  tags = {
    "Environment" = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.policy.arn
}
////////////////define role run codepipeline///////////////////////////
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.environment}-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com",
          "codedeploy.amazonaws.com",
          "codepipeline.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "codepipeline_policy_doc" {
  statement {
    sid = "1"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"
    ]
  }
  statement {
    actions = [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetRepository",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
    ]

    resources = ["*"
    ]
  }

  statement {
    actions = [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
                "codestar-connections:UseConnection"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
               "elasticbeanstalk:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*",
                "sqs:*",
                "ecs:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
                "lambda:InvokeFunction",
                "lambda:ListFunctions",
                "iam:PassRole"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
               "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:CreateChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:BatchGetProjects",
      "codebuild:StartBuild",
      "codebuild:CreateProject",
      "codebuild:DeleteProject"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
    ]

    resources = [
      "*",
    ]
  }
    statement {
    actions = [
                "cloudformation:ValidateTemplate"
    ]

    resources = [
      "*",
    ]
  }
  statement {
    actions = [
                "states:DescribeExecution",
                "states:DescribeStateMachine",
                "states:StartExecution"
    ]

    resources = [
      "*",
    ]
  }
    statement {
    actions = [
                "appconfig:StartDeployment",
                "appconfig:StopDeployment",
                "appconfig:GetDeployment"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name = "${var.environment}-codepipeline_policy"
  path = "/"
  policy = data.aws_iam_policy_document.codepipeline_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  role = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

///////////////////////////define role ECS run//////////////////////////////
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecs-role-execution"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-ecs-role-name-task"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
//attach role 
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "task_s3" {
  role       = "${aws_iam_role.ecs_task_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

////////////////////////define output//////////////////////////////
output "role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}
output "task_execution_role" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
output "iam_role" {
  value = aws_iam_role.iam_role.name
}
