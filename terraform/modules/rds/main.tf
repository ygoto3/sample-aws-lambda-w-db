resource "aws_db_subnet_group" "main" {
    name = "${var.resource_prefix}-main"
    subnet_ids = var.subnet_ids

    tags = {
        Name = "${var.resource_prefix}-main"
    }
}

resource "aws_security_group" "rds" {
    name        = "${var.resource_prefix}-rds-sg"
    vpc_id      = var.vpc_id

    ingress {
        protocol    = "tcp"
        from_port   = 5432
        to_port     = 5432
        security_groups = var.ingress_security_group_ids
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.resource_prefix}-rds-sg"
    }
}

resource "aws_db_instance" "main" {
    identifier              = "${var.resource_prefix}-db"
    db_name                 = "postgres"
    allocated_storage       = 20
    storage_type            = "gp2"
    engine                  = "postgres"
    engine_version          = "16.4"
    instance_class          = "db.t3.small"
    db_subnet_group_name    = aws_db_subnet_group.main.name
    password                = var.db_password
    username                = var.db_username
    backup_retention_period = 0
    multi_az                = false
    skip_final_snapshot     = true
    vpc_security_group_ids  = [aws_security_group.rds.id]

    # provisioner "local-exec" {
    #     command = "PGPASSWORD=${self.password} psql -h localhost -p ${self.port} -U ${self.username} -c 'CREATE TABLE IF NOT EXISTS sample_table (id SERIAL PRIMARY KEY, name VARCHAR(255));'"
    # }

    tags = {
        Name = "${var.resource_prefix}-main"
    }
}
