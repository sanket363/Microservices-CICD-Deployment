#
# Build
#
# FROM debian:10 AS build

# RUN apt-get update && apt-get -y install maven

# WORKDIR /opt/shipping

# COPY pom.xml /opt/shipping/
# RUN mvn dependency:resolve
# COPY src /opt/shipping/src/
# RUN mvn package

# #
# # Run
# #
# FROM openjdk:8-jdk

# EXPOSE 8080

# WORKDIR /opt/shipping

# ENV CART_ENDPOINT=cart:8080
# ENV DB_HOST=mysql

# COPY --from=build /opt/shipping/target/shipping-1.0.jar shipping.jar

# CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]

# Stage 1: Build the Maven project
FROM maven:3.6.3-openjdk-11 AS build

WORKDIR /opt/shipping

# Copy only the POM file to resolve dependencies efficiently
COPY pom.xml .

# Resolve dependencies
RUN mvn -B dependency:resolve dependency:resolve-plugins

# Copy the rest of the source code and build the application
COPY src src
RUN mvn -B package

# Stage 2: Create the final image with the built JAR
FROM openjdk:11-jre-slim

WORKDIR /opt/shipping

# Expose port 8080
EXPOSE 8080

# Copy the built JAR file from the previous stage
COPY --from=build /opt/shipping/target/shipping-1.0.jar shipping.jar

# Define any environment variables if needed
ENV CART_ENDPOINT=cart:8080
ENV DB_HOST=mysql

# Command to run the application
CMD ["java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar"]

