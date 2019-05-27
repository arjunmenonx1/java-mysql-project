FROM tomcat
ENV dburl=${database_url}
ENV dbuser=${database_user}
ENV dbpassword=${database_password}
ARG artifact
COPY ./${artifact} /usr/local/tomcat/webapps
