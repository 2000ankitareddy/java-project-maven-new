# Stage 1: Build with Maven
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .
# Download deps without forcing Sonar if it's plugin-only
RUN mvn dependency:resolve-plugins dependency:resolve -B || true  # || true to ignore minor fails

COPY src ./src

# Build WAR, skip tests & any Sonar-related if bound
RUN mvn clean package -DskipTests

# Stage 2: Tomcat for WAR
FROM tomcat:9.0-jdk17-temurin-focal

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR as ROOT
COPY --from=builder /app/target/myapp.war /usr/local/tomcat/webapps/ROOT.war

# Expose port (Tomcat default 8080, map to 8033 outside)
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]
