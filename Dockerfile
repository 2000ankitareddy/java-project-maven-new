# ---------- Stage 1: Build the application ----------
FROM maven:3.9.9-eclipse-temurin-8 AS builder

WORKDIR /build

# Copy project files
COPY pom.xml .
COPY src ./src

# Build WAR file
RUN mvn clean package -DskipTests


# ---------- Stage 2: Lightweight Runtime ----------
FROM tomcat:9.0-jdk8-temurin

# Remove default applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy generated WAR from build stage
COPY --from=builder /build/target/*.war /usr/local/tomcat/webapps/myapp.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh","run"]
