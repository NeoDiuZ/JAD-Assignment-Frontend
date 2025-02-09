FROM eclipse-temurin:17-jdk-focal AS builder
WORKDIR /app
COPY . .
# Create the gradle wrapper
RUN apt-get update && apt-get install -y gradle
RUN gradle wrapper
# Build with the wrapper
RUN ./gradlew war --stacktrace --info --no-daemon

FROM tomcat:10-jdk17
COPY --from=builder /app/build/libs/app.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
