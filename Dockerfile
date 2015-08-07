############################################################
# Dockerfile to build Galaxy Toolshed
# Based on Ubuntu 14.04
############################################################

# Set the base image to Ubuntu
FROM ubuntu:trusty

# Update the sources list and install basic packages
RUN apt-get update && \
		apt-get install -y tar less git mercurial curl vim wget unzip netcat \
		software-properties-common \
    python-pip \
    python-virtualenv

# Update python setuptools from source
RUN wget https://bitbucket.org/pypa/setuptools/downloads/ez_setup.py -O - | python

# Configure Galaxy Application
ENV GALAXY_HOME /usr/local/galaxy
WORKDIR $GALAXY_HOME

# Add project to the image
ADD galaxy $GALAXY_HOME
RUN ./scripts/common_startup.sh

# Set environment vars that will override basic configuration in tool_shed.ini
ENV TOOL_SHED_CONFIG_FILE=./config/tool_shed.ini \
		BASE_TOOL_SHED=http://toolshed.g2.bx.psu.edu \
		GALAXY_DATA=/data

# Add config files to galaxy
ADD config/tool_shed.ini config/tool_shed.ini
ADD config/user_info.xml lib/tool_shed/scripts/bootstrap_tool_shed/user_info.xml
ADD config/bootstrap.sh bootstrap.sh

RUN ./bootstrap.sh

EXPOSE 9009

ENTRYPOINT ["./run_tool_shed.sh"]
