# Stackdriver trace
# Enable cloud trace API
gcloud services enable cloudtrace.googleapis.com

# Enable GCP spring cloud starter for your services in pom.xml
###        <dependency>
###                <groupId>org.springframework.cloud</groupId>
###                <artifactId>spring-cloud-gcp-starter-trace</artifactId>
###        </dependency>

# In your services application.properties file disable tracing for testing
### spring.cloud.gcp.trace.enabled=false

# Enable trace sampling for the cloud profile in your services application-cloud.properties
### spring.cloud.gcp.trace.enabled=true
### spring.sleuth.sampler.probability=1.0
### spring.sleuth.scheduled.enabled=false

# Set up a service account
gcloud iam service-accounts create my-service-account

# Add the Editor role for your project to this service account.
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:my-service-account@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/editor

# Generate the JSON key file to be used by the application to identify itself using the service account.
gcloud iam service-accounts keys create \
    ~/service-account.json \
    --iam-account my-service-account@${PROJECT_ID}.iam.gserviceaccount.com

# Change to the services directory.
cd ~/app-service

# Start the services application.
./mvnw spring-boot:run \
  -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud \
  -Dspring.cloud.gcp.credentials.location=file:///$HOME/service-account.json"

# Examine the traces
# In the Navigation Menu navigate to Trace > Trace List in the Operations section.
