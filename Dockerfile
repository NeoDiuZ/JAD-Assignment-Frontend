FROM gradle:jdk17 AS builder
WORKDIR /app
COPY . .
RUN gradle war

FROM tomcat:10-jdk17
COPY --from=builder /app/build/libs/app.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
