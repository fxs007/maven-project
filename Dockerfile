FROM tomcat:8.0

ADD ./webapp/target/*.war /usr/local/tomcat/webapps/

#expose container's 8080 on host, but it does not have to be 8080 on host
EXPOSE 8080

CMD ["catalina.sh", "run"]
