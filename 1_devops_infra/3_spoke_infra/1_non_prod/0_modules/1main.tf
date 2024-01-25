##### a role created with assume policy#####
resource "aws_iam_role" "ec2_kops_role" {
  name               = "kops-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
   }

  )
}

####a policy with permissions ########--->admin permissions
resource "aws_iam_policy" "kops_policy" {  
  name        = "kops-policy"
  description = "A kops policy"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}

  )
}

# resource "aws_iam_policy" "kops_policy" {
#   name        = "kops-policy"
#   description = "A kops policy"
#   policy      = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ecr:GetAuthorizationToken",
#           "ecr:BatchGetImage",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:DescribeRepositories",
#           "ecr:ListImages"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": "*",
#         "Resource": "*"
#       }
#     ]
#   })
# }

######attaching both role and policy#########
resource "aws_iam_policy_attachment" "kops-attach" {
  name       = "kops-attachment"
  roles     = ["${aws_iam_role.ec2_kops_role.name}"]
  policy_arn = "${aws_iam_policy.kops_policy.arn}"
}


####creating a instance profile to give in instance creation check below aws_iam_instance_profile while creating instance########33
resource "aws_iam_instance_profile" "kops_profile" {
name  = "kops_profile"                         
role = aws_iam_role.ec2_kops_role.name
}
resource "aws_instance" "server" {
    ami = var.ami
    availability_zone = var.availability_zone
    #availability_zones =var.availability_zones
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet_id
    #subnet_ids = var.subnet_ids
    vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
    # associate_public_ip_address = true
    associate_public_ip_address = var.associate_public_ip_address
    user_data = var.user_data
    iam_instance_profile = "${aws_iam_instance_profile.kops_profile.name}"
    tags = {
        Name = var.instance_name

    }

}
