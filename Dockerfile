FROM tomcat:8.0.20-jre8
COPY target/demo-app-1.0.0.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]