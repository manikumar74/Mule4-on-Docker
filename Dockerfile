FROM java:openjdk-8-jdk
MAINTAINER Mani Rautroy

RUN rm -rf Mule
RUN mkdir Mule

#Add  Mule runtime from our local system to the Docker container
CMD echo "--- Adding Mule4.1.4 runtime in Docker Container ---"
ADD  mule-ee-distribution-standalone-4.1.4.zip /Mule

#Adding Work Directory
CMD echo "--- Adding Work Directory ---"
WORKDIR /Mule

#Extract and install the Mule runtime in the container
CMD echo "--- Unzipping the added zip ---"
RUN         unzip mule-ee-distribution-standalone-4.1.4.zip && \
            rm mule-ee-distribution-standalone-4.1.4.zip
			
# Define volume mount points
VOLUME      ["/Mule/mule-enterprise-standalone-4.1.4/logs", "/Mule/mule-enterprise-standalone-4.1.4/apps", "/Mule/mule-enterprise-standalone-4.1.4/domains"]

# Copy and install license
CMD echo "--- Copy and install license ---"
COPY        license.lic mule-enterprise-standalone-4.1.4/conf/
RUN         mule-enterprise-standalone-4.1.4/bin/mule -installLicense mule-enterprise-standalone-4.1.4/conf/license.lic

#Check if Mule Licence installed
RUN ls -ltr mule-enterprise-standalone-4.1.4/conf/
CMD echo "------ Licence installed ! --------"

#Copy and deploy mule application in runtime
CMD echo "--- Deploying mule application in runtime ---"
COPY  helloworld.zip mule-enterprise-standalone-4.1.4/apps/
RUN ls -ltr mule-enterprise-standalone-4.1.4/apps/

# Expose the necessary port ranges as required by the Mule Apps
EXPOSE      8081-8085
EXPOSE      9000
EXPOSE      9082

# Mule remote debugger
EXPOSE      5000

# Mule JMX port (must match Mule config file)
EXPOSE      1098

# Mule MMC agent port
EXPOSE      7777

# AMC agent port
EXPOSE      9997

# Start Mule runtime
CMD echo "--- Starting Mule runtime ---"
CMD         ["mule-enterprise-standalone-4.1.4/bin/mule"]