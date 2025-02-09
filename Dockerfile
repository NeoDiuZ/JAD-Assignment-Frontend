FROM eclipse-temurin:17-jdk-focal AS builder
WORKDIR /app
COPY . .
RUN chmod +x ./gradlew
# Download the gradle wrapper jar
RUN mkdir -p gradle/wrapper
RUN curl -o gradle/wrapper/gradle-wrapper.jar https://raw.githubusercontent.com/gradle/gradle/v8.5.0/gradle/wrapper/gradle-wrapper.jar
RUN ./gradlew war --no-daemon

FROM tomcat:10-jdk17
# Remove default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=builder /app/build/libs/app.war /usr/local/tomcat/webapps/ROOT.war
# Add environment variables with modern JVM options
ENV CATALINA_OPTS="-Xmx512m -XX:+UseG1GC -XX:+UseStringDeduplication -Djava.security.egd=file:/dev/./urandom"
# Enable Tomcat debug logging
RUN sed -i 's/\.level = INFO/\.level = FINE/g' /usr/local/tomcat/conf/logging.properties
EXPOSE 8080
CMD ["catalina.sh", "run"]
