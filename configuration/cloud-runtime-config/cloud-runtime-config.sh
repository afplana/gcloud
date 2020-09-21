# Spring Cloud GCP to add support for Cloud Runtime Configuration API
# A Cloud Storage bucket that is named using the project ID for this lab is automatically created for you. 
# The source code for your applications is copied into this bucket when the Cloud SQL server is ready.


# Create an environment variable that contains the project ID
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

# Verify  application files.
gsutil ls gs://$PROJECT_ID

# Copy the application folders to Cloud Shell.
gsutil -m cp -r gs://$PROJECT_ID/* ~/

# Make the Maven wrapper scripts executable.
chmod +x ~/app-frontend/mvnw
chmod +x ~/app-service/mvnw

# Add the Spring Cloud GCP Config starter for spring boot
# In pom.xml copy.
###        <dependency>
###            <groupId>org.springframework.cloud</groupId>
###            <artifactId>spring-cloud-gcp-starter-trace</artifactId>
###        </dependency>
###        <dependency>
###           <groupId>org.springframework.boot</groupId>
###           <artifactId>spring-boot-starter-actuator</artifactId>
###        </dependency>
###        <dependency>
###            <groupId>org.springframework.cloud</groupId>
###            <artifactId>spring-cloud-gcp-starter-config</artifactId>
###            <version>1.2.0.RC2</version>
###        </dependency>

# Insert a new section called <repositories> at the bottom of the file, after the <build> section and just before the closing </project> tag.
###    <repositories>
###         <repository>
###              <id>spring-milestones</id>
###              <name>Spring Milestones</name>
###              <url>https://repo.spring.io/milestone</url>
###              <snapshots>
###                  <enabled>false</enabled>
###              </snapshots>
###         </repository>
###    </repositories>

# Configure local profile for spring application
# bootstrap.properties
### spring.cloud.gcp.config.enabled=true
### spring.cloud.gcp.config.name=frontend
### spring.cloud.gcp.config.profile=local

# application.properties
### management.endpoints.web.exposure.include=*

# Configure a cloud profile
# bootstrap-cloud.properties
### spring.cloud.gcp.config.enabled=true
### spring.cloud.gcp.config.name=frontend
### spring.cloud.gcp.config.profile=cloud

### By default, runtime configuration values are read only when an application starts. You should add a Spring Cloud Config @RefreshScope to source files

# Create a runtime configuration
# In the Cloud Shell enable Cloud Runtime Configuration API.
gcloud services enable runtimeconfig.googleapis.com

# Create a runtime configuration for the app-frontend application's local profile.
gcloud beta runtime-config configs create frontend_local

# Set a new configuration value for the greeting message.
gcloud beta runtime-config configs variables set greeting "Hi from Runtime Config" --config-name frontend_local

# Display all the variables in the runtime configuration:
gcloud beta runtime-config configs variables list --config-name=frontend_local

# Enter the following command to display the value of a specific variable
gcloud beta runtime-config configs variables get-value greeting --config-name=frontend_local

# Run the updated application locally
# Change to the guestbook-service directory.
cd ~/app-service

# Run the backend service application.
./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud"

# Change to the app-frontend directory.
cd ~/app-frontend

# Start the frontend application with the cloud profile.
./mvnw spring-boot:run -Dspring.profiles.active=cloud

# Update and refresh a configuration
gcloud beta runtime-config configs variables set greeting \
  "Hi from Updated Config" \
  --config-name frontend_local

# Use curl to trigger Spring Boot Actuator so that it reloads configuration values from the Runtime Configuration API service.
curl -XPOST http://localhost:8080/actuator/refresh

