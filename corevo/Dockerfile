# Stage 1: Use Maven for building
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml ./
COPY src ./src
RUN mvn clean package -DskipTests

# Satge 2: Use OpenJDK for running
FROM openjdk:21-jdk-slim
WORKDIR /app
COPY --from=build /app/target/corevo-0.0.1-SNAPSHOT.jar corevo.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","corevo.jar"]
