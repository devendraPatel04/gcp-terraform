region="asia-south1"
project_id="paltech-trainings"

## Networking Components
vpcs = {
  prod = {
    name                    = "prod-vpc-dev"
    auto_create_subnetworks = false
    delete_default_routes_on_create = true
  }

  nonprod = {
    name                    = "nonprod-vpc"
    auto_create_subnetworks = false
    delete_default_routes_on_create = false
  }
}
subnets = {
  prod_app = {
    name    = "prod-app-subnet"
    region  = "asia-south1"
    cidr    = "10.10.0.0/24"
    vpc_key = "prod"
  }
  # prod_db = {
  #   name    = "prod-db-subnet"
  #   region  = "asia-south1"
  #   cidr    = "10.10.1.0/24"
  #   vpc_key = "prod"
  # }
  # nonprod_app = {
  #   name    = "nonprod-app-subnet"
  #   region  = "asia-south1"
  #   cidr    = "10.20.0.0/24"
  #   vpc_key = "nonprod"
  # }
}
routes = {
  prod_app = {
    name        = "prod-route"
    dest_range = "15.0.0.0/8"
    vpc_key    = "prod"
    next_hop_ip = "10.10.0.3"
    priority   = 100
  }
  prod_igw = {
    name        = "prod-igw-route"
    dest_range = "0.0.0.0/0"
    vpc_key    = "prod"
    next_hop_gateway  = "default-internet-gateway"
    priority   = 100
  }
  # nonprod_app = {
  #   name        = "nonprod-route"
  #   dest_range = "15.0.0.0/8"
  #   vpc_key    = "nonprod"
  #   next_hop_ip = "10.20.0.0"
  #   priority   = 100
  # }
}
firewallrules = {
  allow-web = {
    name     = "allow-web"
    vpc_key  = "prod"
    priority = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["web"]
    allow = [
      {
        protocol = "icmp"
      },
      {
        protocol = "tcp"
        ports    = ["80", "443", "22"]
      }
    ]
  }
  # allow-icmp = {
  #   name     = "allow-icmp"
  #   vpc_key  = "nonprod"
  #   priority = 65534

  #   source_ranges = ["10.0.0.0/8"]

  #   allow = [
  #     {
  #       protocol = "icmp"
  #     }
  #   ]
  # }
}

## Compute
instances = {
  web1 = {
    name         = "prod-web-1"
    zone         = "asia-south1-a"
    machine_type = "e2-medium"

    network_key = "prod"
    subnet_key  = "prod_app"

    tags = ["web"]
    labels = {
      env = "prod"
    }

    boot_disk = {
      image = "debian-cloud/debian-12"
      size  = 30
    }

    public_ip = true
    
    #somekind of permission issue that why it is not working(not sure)
    startup_script_path = "scripts/installNginx.sh"

    ssh_user = "dev_patel"
    ssh_public_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGd28FeZYot2xnPlE7Su3SUGNz48pWOn+0qR7Gf5MDX0"

    # service_account = {
    #   email  = "vm-sa@paltech-trainings.iam.gserviceaccount.com"
    #   scopes = ["cloud-platform"]
    # }
  }

  # db1 = {
  #   name         = "prod-db-1"
  #   zone         = "asia-south1-b"
  #   machine_type = "e2-standard-2"

  #   network_key = "prod"
  #   subnet_key  = "prod_db"
  #   tags = ["db"]

  #   ssh_user = "dev_patel"
  #   ssh_public_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGd28FeZYot2xnPlE7Su3SUGNz48pWOn+0qR7Gf5MDX0 dev_patel"

  #   boot_disk = {
  #     image = "debian-cloud/debian-12"
  #     size  = 50
  #   }

  #   public_ip = false
  # }
}

#Storage
buckets = {
   appengine = {
    name                        = "appenginebucketpoc"
    location                    = "asia-south1"
    storage_class               = "Standard"
    uniform_bucket_level_access = true
  }
}

#Cloud Run
cloudrun_services = {
  api = {
    name   = "dev-api"
    region = "asia-south1"
    image  = "us-docker.pkg.dev/cloudrun/container/hello"
    public = false
  }

  web = {
    name   = "dev-web"
    region = "asia-south1"
    image  = "us-docker.pkg.dev/cloudrun/container/hello"
    public = true
  }
}

#App Engine
create_app_engine = false

app_engine_location_id = "asia-south1"

app_engine_services = {
  default = {
    service_name = "default"
    runtime      = "nodejs20"
    version_id   = "v1"

    entrypoint = {
      shell = "node server.js"
    }

    source_url   = "https://storage.googleapis.com/appengine-artifacts/devbucketpoc.zip"
    env_vars = {
      ENV = "prod"
    }

    api = {
      service_name = "api"
      runtime      = "nodejs20"
      version_id   = "v1"

      entrypoint = {
        shell = "node server.js"
      }

      source_url   = "https://storage.googleapis.com/appengine-artifacts/devbucketpoc.zip"
      env_vars = {
        ENV = "prod"
      }
    }
  }
}