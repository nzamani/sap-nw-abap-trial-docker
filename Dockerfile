FROM opensuse/leap:latest

ENV LANG=en_US.UTF-8

RUN zypper --non-interactive install --replacefiles which hostname expect net-tools iputils wget vim iproute2 unrar less tar gzip uuidd tcsh libaio
#RUN zypper refresh && zypper --non-interactive up

# uuidd is needed by nw abap
RUN mkdir /run/uuidd && chown uuidd /var/run/uuidd && /usr/sbin/uuidd

# Copy expect script + the extracted SAP NW ABAP files to the container
COPY install.exp /tmp/sapdownloads/
COPY sapdownloads/TD752SP01 /tmp/sapdownloads/

WORKDIR /tmp/sapdownloads

RUN chmod +x install.sh install.exp

# Important ports to be exposed (TCP):
# HTTP
EXPOSE 8000
# HTTPS
EXPOSE 44300
# ABAP in Eclipse
EXPOSE 3300
# SAP GUI
EXPOSE 3200
# SAP Cloud Connector
# EXPOSE 8443

# Unfortunatelly, we cannot run the automated installation directly here!
# Solution: run original install.sh or the automated install.exp after the image has been created
# RUN ./install.exp

