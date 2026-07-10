resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" // / or " or @ could cause issues with connection strings, so we exclude them
}

// defining where it can live at least 2 subnets are required by aws
resource "aws_db_subnet_group" "main" {
  name       = "app-db-subnet-group"
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  tags       = { Name = "db-subnet-group" }
}

resource "aws_db_instance" "postgres" {
  identifier           = "app-migration-db"
  engine               = "postgres"
  engine_version       = "16.4"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20 // minimum storage size for gp3 is 20GB
  storage_type         = "gp3" // disk type, gp3 is the latest generation of general purpose SSDs, and is cheaper than gp2
  db_name              = var.db_name // only accepts underscores, no hyphens, and must start with a letter
  username             = var.db_username
  password             = random_password.db_password.result
  
  publicly_accessible  = false
  skip_final_snapshot  = true // normally, when you delete an RDS database, AWS offers to take one last backup snapshot first, just in case, we dont need that so we disable it
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}
