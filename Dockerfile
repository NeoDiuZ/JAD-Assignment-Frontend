FROM gradle:jdk17 AS builder
WORKDIR /app
COPY . .
# Run Gradle with debug output
RUN gradle war --stacktrace --info

FROM tomcat:10-jdk17
COPY --from=builder /app/build/libs/app.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
