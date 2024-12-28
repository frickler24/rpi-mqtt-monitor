FROM ubuntu:latest

RUN apt update \
	&& apt upgrade -y \
	&& apt install -y \
		git \
		curl \
		python3 \
		pip

RUN apt install -y \
	cron \
	python3.12-venv \
	python3-venv \
	vim \
	htop \
	sudo

#
# See comment below
ARG MYPASSWD

# Create new user with hardly any permission
RUN useradd --groups sudo --create-home --shell /bin/bash monitor && echo monitor:$MYPASSWD | chpasswd

WORKDIR /home/monitor

# clone and build the app, changing INCUBATOR_VER will break the cache here
ARG INCUBATOR_VER=unknown
RUN curl -s https://raw.githubusercontent.com/frickler24/rpi-mqtt-monitor/other_machines/remote_install.sh > /tmp/inst.sh

#
# Definition der Eingaben in das Install-Script
COPY ./infile.txt /tmp/infile.txt
RUN chmod 755 /tmp/inst.sh

# Perform the install
RUN /tmp/inst.sh < /tmp/infile.txt
RUN chown monitor:monitor -R rpi*
RUN rm -f /tmp/inst.sh /tmp/infile.txt

# allow user monitor to use two programs: apt and apt-get to update the system.
# Updating the software should be allowed by git in the home directory
RUN echo "monitor ALL=(ALL:ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get" > /etc/sudoers.d/monitor

USER monitor
CMD ["rpi-mqtt-monitor/rpi_mon_env/bin/python3", "rpi-mqtt-monitor/src/rpi-cpu2mqtt.py", "--service"]
