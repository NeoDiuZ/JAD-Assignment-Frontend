FROM eclipse-temurin:17-jdk-focal AS builder
WORKDIR /app
COPY . .
RUN chmod +x ./gradlew
# Download the gradle wrapper jar
RUN mkdir -p gradle/wrapper
RUN curl -o gradle/wrapper/gradle-wrapper.jar https://raw.githubusercontent.com/gradle/gradle/v8.5.0/gradle/wrapper/gradle-wrapper.jar
RUN ./gradlew war --no-daemon

FROM tomcat:10-jdk17
COPY --from=builder /app/build/libs/app.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
