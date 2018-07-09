FROM openjdk:8u171-slim-stretch

MAINTAINER "Paul Hoang 2018/06/17"

ARG APP_VERSION
ENV JAR_VERSION=$APP_VERSION
COPY ["downloads/com/paulhoang/reborn-service-discovery/$JAR_VERSION/app.jar", "app.jar"]
ENTRYPOINT ["java", "-jar", "app.jar"]