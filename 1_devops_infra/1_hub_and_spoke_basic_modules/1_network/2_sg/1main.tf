resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = var.vpc_id #here .id is attribute and name,descrption,..all are arguments 
                                        #commonly used attributes(one resource reference to another resource)
                                        # are .id, .name, .arn 
#ingress means inbound rules (if we want to add any new port change ingress)
#  just change from_port and to_port ex:from_port=8080,to_port=8080 
# ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#egress means outbound rules
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #[] means arrays i.e in list (is string error comes )
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}