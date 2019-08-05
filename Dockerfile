FROM opensuse/leap:latest

ENV LANG=en_US.UTF-8

COPY install.exp /tmp/sapdownloads/
COPY sapdownloads /tmp/sapdownloads/
COPY sapdownloads/SYBASE_ASE_TD.lic /tmp/sapdownloads/server/TAR/x86_64

WORKDIR /tmp/sapdownloads

ENV HOSTNAME vhcalnplci

RUN zypper --non-interactive install --replacefiles which hostname expect net-tools iputils wget vim iproute2 unrar tar uuidd tcsh gzip net-tools libaio && \
 mkdir /run/uuidd && chown uuidd /var/run/uuidd && /usr/sbin/uuidd && \
 echo "vhcalnplci" >> /etc/hostname && echo $(grep $(hostname) /etc/hosts | cut -f1) vhcalnplci >> /etc/hosts \
 chmod +x install.sh && chmod +x install.exp && ./install.exp && cd / && rm -rf /tmp/sapdownloads/ 

# Important ports to be exposed (TCP):
# HTTP
EXPOSE 8000
# HTTPS
EXPOSE 44300
# ABAP in Eclipse
EXPOSE 3300
# SAP GUI
EXPOSE 3200
# SAP Cloud Connector (not part of installation, so no need to be exposed)
# EXPOSE 8443
