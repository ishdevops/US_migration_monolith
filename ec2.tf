resource "aws_instance" "prod_sql_server" {
    ami                         = "ami-04540020f28b7463c"
    instance_type               = "r5a.2xlarge"
    subnet_id                   = "private_subnet_a"
    vpc_security_group_ids      = ["sql_server_sg", "windows_rdp"]
    associate_public_ip_address = "false"
    disable_api_termination     = "true"

    tags = {
        name = "Prod-SQL-Server"
    }
}

resource "aws_instance" "jumpbox" {
    ami                         = "ami-0b9482d3216554966"
    instance_type               = "t3a.medium"
    subnet_id                   = "public_subnet_a"
    vpc_security_group_ids      = ["jumpbox_sg", "sql_server_sg", "windows_rdp"]
    associate_public_ip_address = "true"
    disable_api_termination     = "true"

    tags = {
        name = "Jumpbox-Server"
    }
}