FROM maven:3.5.3-alpine as build
WORKDIR /app
RUN mvn clean package

FROM openjdk:7u91-jdk-alpine
RUN mkdir /opt/app
ENV PROJECT_HOME /app
COPY --from=build /app/target/*.jar $PROJECT_HOME/
WORKDIR $PROJECT_HOME
EXPOSE 8080
CMD [ "java","-jar","./*.jar" ]