# Use a base image with Java and Maven installed
FROM adoptopenjdk:17-jdk-hotspot AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project file
COPY demo/pom.xml .

# Build only the dependencies
RUN mvn dependency:go-offline -B

# Copy the source code
COPY demo/src ./src

# Build the application
RUN mvn package -DskipTests

# Use a minimal base image for runtime
FROM adoptopenjdk:17-jre-hotspot

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/demo/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Set the entrypoint command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
