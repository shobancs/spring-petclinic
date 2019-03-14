FROM java:8-jre
MAINTAINER "Shoban Cheekuru<shoban.cs@gmail.com>"

RUN mkdir spring-petclinic
COPY target/spring*.jar /spring-petclinic/spring-petclinic.jar
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/spring-petclinic/spring-petclinic.jar"]

