#!/bin/bash
#Install gpg key
sudo apt-get install -y gnupg 
# Edit the following to change the name of the database that is created (defaults to the user name)
APP_DB_USER=postgres
APP_DB_NAME=${APP_DB_USER}_lab

# Edit the following to change the version of PostgreSQL that is installed
PG_VERSION=13

export DEBIAN_FRONTEND=noninteractive

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi

# Update package list and upgrade all packages
apt-get update && \
apt-get -y upgrade && \

apt-get -y install "postgresql-$PG_VERSION" "postgresql-client-$PG_VERSION" pwgen && \

APP_DB_PASS=`pwgen 10 1`
sudo usermod --password $(echo $APP_DB_PASS | openssl passwd -1 -stdin) postgres


PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF" && \

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$PG_CONF"

# Reload postgresql config:
service postgresql reload

# if you have more complex things you'll need to put that in a create_db.sql file and run the script as
#sudo -u postgres psql < create_db.sql

cat <<EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';
-- Create the database:
CREATE DATABASE $APP_DB_NAME WITH OWNER=$APP_DB_USER
                                  LC_COLLATE='en_US.utf8'
                                  LC_CTYPE='en_US.utf8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;
EOF

# Tag the provision time:
#date > "$PROVISIONED_ON"

echo "Successfully created PostgreSQL dev virtual machine."
echo ""

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "Your PostgreSQL database has been setup and can be accessed on your local machine on the forwarded port (default: 5432)"
  echo "  Host: localhost"
  echo "  Database: $APP_DB_NAME"
  echo "  Username: $APP_DB_USER"
  echo "  Password: $APP_DB_PASS"
  echo "  Port: 5432"
  echo ""
  echo "Admin access to postgres user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo ""
  echo "psql access to app database user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo "psql and then \c $APP_DB_NAME or psql -c "\c $APP_DB_NAME""
  echo ""
  echo ""
  echo "Env variable for application development:"
  echo "  DATABASE_URL=postgresql://$APP_DB_USER:$APP_DB_PASS@localhost:5432/$APP_DB_NAME"
  echo ""
  echo "Local command to access the database via psql:"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost -p 5432 $APP_DB_NAME"
}


print_db_usage


