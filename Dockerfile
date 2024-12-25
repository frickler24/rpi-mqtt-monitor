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
# Siehe Kommentar unten
ARG MYPASSWD
ARG MQTTPASSWD
RUN useradd --groups sudo --create-home --shell /bin/bash monitor && echo monitor:$MYPASSWD | chpasswd

WORKDIR /home/monitor

RUN curl -s https://raw.githubusercontent.com/frickler24/rpi-mqtt-monitor/other_machines/remote_install.sh > /tmp/inst.sh
#
# Hier sind einige Elemente neu zugewiesen, die im Original File anders definiert sind
COPY ./config.py /tmp/config.py
#
# Definition der Eingaben in das Install-Script
COPY ./infile.txt /tmp/infile.txt
#
# Das Makefile muss aufgerufen werden mit zwei Secrets:
# PASSWORD=<Dein Passwort für User monitor> MQTTPASSWD=<Dein MQTT-User-PW> make clean image 
RUN echo MQTTPASSWD = $MQTTPASSWD && sed -i s/GEHEIMESPASSWORT/$MQTTPASSWD/ /tmp/infile.txt
RUN chmod 755 /tmp/inst.sh
RUN /tmp/inst.sh < /tmp/infile.txt
RUN chown monitor:monitor -R rpi*
RUN cat /tmp/config.py >> rpi-mqtt-monitor/src/config.py
RUN rm -f /tmp/inst.sh /tmp/infile.txt /tmp/config.pi
USER monitor

CMD ["rpi-mqtt-monitor/rpi_mon_env/bin/python3", "rpi-mqtt-monitor/src/rpi-cpu2mqtt.py", "--service"]
