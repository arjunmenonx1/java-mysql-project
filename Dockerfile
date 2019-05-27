FROM tomcat
ARG dburl
ARG dbuser
ARG dbpassword
ENV dburl=${dburl}
ENV dbuser=${dbuser}
ENV dbpassword=${dbpassword}
ARG artifact
COPY ./${artifact} /usr/local/tomcat/webapps
