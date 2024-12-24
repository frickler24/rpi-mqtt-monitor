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

ARG	MYPASSWD
ARG MQTTPASSWD
RUN useradd --groups sudo --create-home --shell /bin/bash monitor && echo monitor:$MYPASSWD | chpasswd

WORKDIR /home/monitor

RUN curl -s https://raw.githubusercontent.com/hjelev/rpi-mqtt-monitor/master/remote_install.sh > /tmp/inst.sh
COPY ./_rpi-mqtt-monitor_src_config.py /tmp/config.py
COPY ./infile.txt /tmp/infile.txt
RUN echo MQTTPASSWD = $MQTTPASSWD && sed -i s/GEHEIMESPASSWORT/$MQTTPASSWD/ /tmp/infile.txt
RUN chmod 755 /tmp/inst.sh
RUN /tmp/inst.sh < /tmp/infile.txt
RUN chown monitor:monitor -R rpi*
RUN rm -f /tmp/inst.sh /tmp/infile.txt
USER monitor

CMD ["rpi-mqtt-monitor/rpi_mon_env/bin/python3", "rpi-mqtt-monitor/src/rpi-cpu2mqtt.py", "--service"]