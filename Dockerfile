# Stage 1: Build the JAR with Maven
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml first for dependency caching
COPY pom.xml .

# Download dependencies (cache layer)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the project (skip tests if you want faster)
RUN mvn clean package -DskipTests

# Stage 2: Runtime image - slim & secure
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy only the final JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the custom port you want (8033)
EXPOSE 8033

# Run the application
# Option 1: Simple (default)
CMD ["java", "-jar", "app.jar"]

# Option 2: If you need to force port via ENV (Spring Boot example)
# ENV SERVER_PORT=8033
# CMD ["java", "-jar", "app.jar"]
