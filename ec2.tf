// resource "aws_instance" "prod_sql_server" {
//     ami                         = "ami-04540020f28b7463c"
//     instance_type               = "r5a.2xlarge"
//     subnet_id                   = aws_subnet.private_subnet_a.id
//     vpc_security_group_ids      = [aws_security_group.sql_server_sg.id, aws_security_group.windows_rdp.id]
//     associate_public_ip_address = "false"
//     disable_api_termination     = "true"

//     tags = {
//         name = "prod-sql-server"
//     }
// }

// resource "aws_instance" "jumpbox" {
//     ami                         = "ami-0b9482d3216554966"
//     instance_type               = "t3a.medium"
//     subnet_id                   = aws_subnet.public_subnet_a.id
//     vpc_security_group_ids      = [aws_security_group.jumpbox_sg.id, aws_security_group.sql_server_sg.id, aws_security_group.windows_rdp.id]
//     associate_public_ip_address = "true"
//     disable_api_termination     = "true"

//     tags = {
//         name = "jumpbox-server"
//     }
// }