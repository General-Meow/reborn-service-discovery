FROM openjdk:8u171-slim-stretch

MAINTAINER "Paul Hoang 2018/06/17"

COPY ["downloads/app.jar", "app.jar"]
ENTRYPOINT ["java", "-jar", "app.jar"]