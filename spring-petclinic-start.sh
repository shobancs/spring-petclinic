#!/bin/bash

mvn clean install
docker build -t shobancs/spring-petclinic .
docker rm spring-petclinic -f
docker push shobancs/spring-petclinic
docker run -dt -p 8085:8080 --name spring-petclinic shobancs/spring-petclinic
