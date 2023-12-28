resource "aws_workspaces_directory" "existing_directory" {
  directory_id = var.directory_id
  subnet_ids = var.subnet_id
}

data "aws_workspaces_bundle" "value_windows_10" {
  bundle_id = var.bundle_id
}

resource "aws_workspaces_workspace" "example" {
  directory_id = var.directory_id
  bundle_id    = data.aws_workspaces_bundle.value_windows_10.id
  user_name    = var.user_name



  workspace_properties {
    compute_type_name                         = "STANDARD"
    user_volume_size_gib                      = 50
    root_volume_size_gib                      = 80
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }

}
# resource "aws_iam_role" "workspaces_default_role" {
#   name = "workspaces_DefaultRole"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "workspaces.amazonaws.com"
#       }
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_policy_attachment" "workspaces_default_policy" {
#   name        = "attach-workspaces-default-policy"  # Give it a name
#   policy_arn  = "arn:aws:iam::aws:policy/AmazonWorkSpaces_DefaultRole"
#   roles       = [aws_iam_role.workspaces_default_role.name]
# }

# # Add any additional permissions you need for the role here

# Create an IP control group for WorkSpaces
resource "aws_workspaces_ip_group" "example_ip_group" {
  name        = "example-ip-group"
  description = "Example IP Control Group"

  rules {
    description = "Allow access from specific IPs"
    source      = "22.22.21.22/32"  # Replace with your desired IP range
  }
}

