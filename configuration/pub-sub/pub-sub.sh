# Enable Cloud Pub/Sub API
gcloud services enable pubsub.googleapis.com

# Create a Cloud Pub/Sub topic
gcloud pubsub topics create messages

# Add Spring Cloud GCP Pub/Sub starter
# pom.xml
###     <dependency>
###          <groupId>org.springframework.cloud</groupId>
###          <artifactId>spring-cloud-gcp-starter-pubsub</artifactId>
###     </dependency>

# Publish a message
# Import
### import org.springframework.cloud.gcp.pubsub.core.*;
# Available bean when you add the dependency
### @Autowired private PubSubTemplate pubSubTemplate;
# Usage
### pubSubTemplate.publish("messages", name + ": " + message);

# Test the application in the Cloud Shell
cd ~/app-service && ./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud"


# Create a new Cloud Pub/Sub subscription
gcloud pubsub subscriptions create messages-subscription-1 \
  --topic=messages

# Pull messages from the subscription.
gcloud pubsub subscriptions pull messages-subscription-1

# Pull the message again and remove it from the subscription by using the auto-acknowledgement switch at the command line.
### gcloud pubsub subscriptions pull messages-subscription-1 --auto-ack

# Process messages in subscriptions
# Generate new project from spring.initzr with name message-processor
cd ~
curl https://start.spring.io/starter.tgz \
  -d dependencies=web,cloud-gcp-pubsub \
  -d baseDir=message-processor | tar -xzvf -

# Add in pom.xml
###     <dependencies>
###          <dependency>
###               <groupId>org.springframework.cloud</groupId>
###               <artifactId>spring-cloud-gcp-starter-pubsub</artifactId>
###          </dependency>
###          <dependency>
###               <groupId>org.springframework.boot</groupId>
###               <artifactId>spring-boot-starter-test</artifactId>
###               <scope>test</scope>
###          </dependency>
###   </dependencies>

# Needed Imports
### import org.springframework.context.annotation.Bean;
### import org.springframework.boot.ApplicationRunner;
### import org.springframework.cloud.gcp.pubsub.core.*;

# Example code in java 
### @Bean
### public ApplicationRunner cli(PubSubTemplate pubSubTemplate) {
### 	return (args) -> {
### 		pubSubTemplate.subscribe("messages-subscription-1",
###			(msg) -> {
###				System.out.println(msg.getPubsubMessage()
###					.getData().toStringUtf8());
###				msg.ack();
###			});
###	};
### }

# Run processor
cd ~/message-processor && ./mvnw -q spring-boot:run

# 


