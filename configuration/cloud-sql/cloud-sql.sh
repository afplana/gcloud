# Enable cloud sql admin api
gcloud services enable sqladmin.googleapis.com

# Confirm that Cloud SQL Administration API is enabled.
gcloud services list | grep sqladmin

# List the Cloud SQL instances.
gcloud sql instances list

# Provision a new Cloud SQL instance.
gcloud sql instances create db_instance_name --region=us-central1


# Create a messages database in the MySQL instance.
gcloud sql databases create database_name --instance db_instance_name

# By default, Cloud SQL is not accessible through public IP addresses. You can connect to Cloud SQL in the following ways:
## Use a local Cloud SQL proxy.
## Use gcloud to connect through a CLI client.
## From a the Java application, use the MySQL JDBC driver with an SSL socket factory for secured connection.


#This command temporarily whitelists the IP address for the connection. Prompt for password but is empty by default
gcloud sql connect db_instance_name

# visualize created databases
show databases;

# Switch to the messages database.
use database_name;

# Create sample table
CREATE TABLE guestbook_message (
  id BIGINT NOT NULL AUTO_INCREMENT,
    name CHAR(128) NOT NULL,
      message CHAR(255),
        image_uri CHAR(255),
	  PRIMARY KEY (id)
 );


# In the Cloud Shell find the instance connection name by running the following command:
gcloud sql instances describe guestbook --format='value(connectionName)'

# Testing app
curl -XPOST -H "content-type: application/json" -d '{"name": "Alain", "message": "Hello Cloud SQL"}' http://localhost:8081/messages

curl http://localhost:8081/guestbookMessages



