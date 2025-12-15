FROM maven:3.9-eclipse-temurin-25 AS build

WORKDIR /app

COPY pom.xml /app/pom.xml

COPY /src /app/src

COPY . .

RUN mvn clean package -DskipTests

FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

ENV MYSQL_USER=petclinic

ENV MYSQL_PASS=petclinic

ENV MYSQL_URL=jdbc:mysql://mysql:3306/petclinic

ENV MYSQL_ROOT_PASSWORD=root

COPY . .

COPY  --from=build /app/target/*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "/app/app.jar", "--spring.profiles.active=mysql"]
