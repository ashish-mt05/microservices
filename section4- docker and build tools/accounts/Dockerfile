#Start with a base image containing Java runtime
FROM openjdk:17-jdk-slim

#Information around who maintains the image
MAINTAINER eazybytes.com

# copy local accounts-0.0.1-SNAPSHOT jar file to container root folder
COPY target/accounts-0.0.1-SNAPSHOT.jar accounts-0.0.1-SNAPSHOT.jar

# execute the application
#ENTRYPOINT execute when we run container from image, and CMD run while docker image build.
ENTRYPOINT ["java", "-jar", "accounts-0.0.1-SNAPSHOT.jar"]