# Use Maven image to build the application
FROM maven:3.8.7-openjdk-11 AS build

# Set working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Use UBI minimal image for running the application
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

LABEL maintainer="Muhammad Edwin <edwin at redhat dot com>"
LABEL BASE_IMAGE="registry.access.redhat.com/ubi8/ubi-minimal:8.5"
LABEL JAVA_VERSION="11"

# Install Java runtime
RUN microdnf install --nodocs java-11-openjdk-headless && microdnf clean all

# Set working directory
WORKDIR /work/

# Copy the built jar from the Maven build stage
COPY --from=build /app/target/*.jar /work/application.jar

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "application.jar"]
