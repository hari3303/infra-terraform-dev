# Define the IAM Role for Amazon EKS
resource "aws_iam_role" "eks_access_role" {
  name = "eks-access-role"
  
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}
# resource "aws_iam_policy" "eks_policy" {  # ---->we can create permissions like this or like below arn directly
#   name        = "eks-policy"
#   description = "A policy for Amazon EKS"
#   policy      = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "eks:DescribeCluster",
#                 "eks:ListClusters",
#                 "eks:CreateCluster",
#                 "eks:DeleteCluster",
#                 "eks:UpdateClusterConfig",
#                 "eks:UpdateClusterVersion",
#                 "eks:UpdateNodegroupConfig",
#                 "eks:CreateNodegroup",
#                 "eks:DeleteNodegroup",
#                 "eks:DescribeNodegroup",
#                 "eks:ListTagsForResource"
#             ],
#             "Resource": "*"
#         }
#     ]
#   })
# }

####a policy with permissions ########--->admin permissions
resource "aws_iam_policy" "eks_policy" {  
  name        = "eks-policy"
  description = "A eks policy"
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

# Attach a policy with Amazon EKS permissions to the IAM Role---->arn has all necessary permissions if you don't want like arn use above code and in arn modify the code like commented line
resource "aws_iam_policy_attachment" "eks_access_policy_attachment" {
  name       = "eks-access-policy-attachment"
  # policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  policy_arn = "${aws_iam_policy.eks_policy.arn}"
  roles      = [aws_iam_role.eks_access_role.name]
}
resource "aws_iam_instance_profile" "eks_profile" {
name  = "eks_profile"                         
role = aws_iam_role.eks_access_role.name
}


resource "aws_instance" "server" {
    ami = var.ami
    availability_zone = var.availability_zone
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet_id
    vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
    # associate_public_ip_address = true
    associate_public_ip_address = var.associate_public_ip_address
    user_data = var.user_data
    iam_instance_profile ="${aws_iam_instance_profile.eks_profile.name}"
    tags = {
        Name = var.instance_name

    }

}
