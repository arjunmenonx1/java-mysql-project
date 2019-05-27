FROM tomcat
ARG artifact
COPY ./${artifact} /usr/local/tomcat/webapps
