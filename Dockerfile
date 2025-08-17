# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-11 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Create runtime image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

LABEL maintainer="Muhammad Edwin <edwin at redhat dot com>"
LABEL BASE_IMAGE="registry.access.redhat.com/ubi8/ubi-minimal:8.5"
LABEL JAVA_VERSION="11"

RUN microdnf install --nodocs java-11-openjdk-headless && microdnf clean all

WORKDIR /work/
COPY --from=build /app/target/*.jar /work/application.jar

EXPOSE 8080
CMD ["java", "-jar", "application.jar"]
