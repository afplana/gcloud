# Configure Cloud profile
## Add to pom.xml:
      <dependency>
         <groupId>org.springframework.cloud</groupId>
         <artifactId>spring-cloud-gcp-starter-sql-mysql</artifactId>
      </dependency>

## To continue to use the demo application for local runs, you disable the Cloud SQL starter in the default application profile by updating the application.properties file.
spring.cloud.gcp.sql.enabled=false

## In the Cloud Shell code editor create an application-cloud.properties file in the src/main/resources directory.
## and add the following properties
spring.cloud.gcp.sql.enabled=true
spring.cloud.gcp.sql.database-name=messages
spring.cloud.gcp.sql.instance-connection-name=YOUR_INSTANCE_CONNECTION_NAME

## Add the following property src/main/resources/application-cloud.properties 
## that should still be open in the Cloud Shell code editor to specify the connection pool size.
spring.datasource.hikari.maximum-pool-size=5

## Run tests to be sure no failures
./mvnw test

## Start the app Service with the cloud profile. 
## Alternatively create SPRING_PROFILES_ACTIVE env variable in your cloud
./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud"


