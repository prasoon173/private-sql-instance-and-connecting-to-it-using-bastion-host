variable "project_id"{
    type =string
    default = "<put you project id here>"
}

variable "region"{
    description = "Region for GCP resources"
    default = "us-central1"
}

variable "zone"{
    description = "Any Particular zone in that region"
    default = "us-central1-a"
}

variable "database_version"{
    description = "The version of the database"
    default = "MYSQL_8_0"
}

variable "activation_policy"{
    description = "This specifies when the instance should be active"
    default = "ALWAYS"
}

variable "availability_type"{
    description = "This specifies whether a instance will be zonal or regional"
    default = "ZONAL"
}

variable "disk_autoresize"{
    description = "Configuration to increase storage size automatically"
    default = "true"
}

variable "disk_size"{
    description = "size of an instance in GB, it couldn't be reduced, but could only be increased"
    default = 10
}

variable "disk_type"{
    description = "PD_SSD or PD_HDD"
    default = "PD_HDD"
}

variable "tier"{
    description = "standard machine"
    default = "db-f1-micro"
}

variable "db_name"{
    description = "default name of the database to create"
    default = "private-sql-instance-demo"
}

variable "user_name"{
    description = "The name of the default user"
    default = "user1"
}

variable "user_host"{
    description = "The host for the default user"
    default = "%"
}

# EOF are Terraform’s heredoc syntax, which allows you to create multiline strings without having to put \n all over the place  

variable "user_password"{
    description = <<EOF                                           
    { "The password for the default user. If not set, a random one will be generated 
    and availabe in generated_user_password output variable" 
    }
    EOF
    default = "root-password"
}

# Here you could put your any of the available vpc. I have created a new one with custom subnet. 

variable "name" {
  description = "The name of the VPC to create"
  type        = string
  default = "new-vpc-sql"
}
