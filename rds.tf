#create a security group for RDS database instance
resource "aws_db_subnet_group" "database" {
  name = "database-mysql-subnet-private-group"
  subnet_ids = local.subnet_private_ids
}
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [ local.subnet_public[0].cidr_block ]
  }
  egress {
    from_port = 0
    to_port =  0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name= "rds-security-group"
  }
}

resource "aws_db_instance" "default" {
  engine = "mysql"
  engine_version = "8.0.33"
  instance_class = local.vars.mysql_instance_type

  db_name = local.vars.mysql_database
  username = local.vars.mysql_username
  password = local.vars.mysql_password

  port = local.vars.mysql_port

  db_subnet_group_name = aws_db_subnet_group.database.name

  storage_type = local.vars.mysql_instance_type
  allocated_storage = local.vars.mysql_allocated_storage

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot =  true

  tags = {
    name = "rds-mysql"
  }
}