# Stage 1: Build the JAR with Maven
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom first → cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source & build
COPY src ./src
RUN mvn clean package -DskipTests   # Remove -DskipTests if tests important

# Stage 2: Lightweight runtime
FROM eclipse-temurin:17-jre-alpine

# Create non-root user for security (good practice)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy JAR from builder
COPY --from=builder /app/target/*.jar app.jar

# Change ownership to non-root
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose your custom port
EXPOSE 8033

# For Spring Boot: Override port via ENV (uncomment if needed)
# ENV SERVER_PORT=8033

# Run the app
CMD ["java", "-jar", "app.jar"]

# Optional: Healthcheck (if app has /actuator/health or similar endpoint)
# HEALTHCHECK --interval=30s --timeout=3s \
#   CMD wget --no-verbose --tries=1 --spider http://localhost:8033/actuator/health || exit 1
