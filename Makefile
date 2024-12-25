
it: clean image monitor

clean:
	-docker rm -f monitor

monitor:
	docker run -d \
		--hostname FROM-$(shell hostname) \
		--restart unless-stopped \
		--name monitor \
		monitor

monitor_cmd:
	docker run -d \
		--hostname FROM-$(shell hostname) \
		--restart unless-stopped \
		--name monitor \
		--user monitor \
		monitor sh -c \
			"cd /rpi-mqtt-monitor; \
			 rpi-mqtt-monitor/rpi_mon_env/bin/python3 \
			 rpi-mqtt-monitor/src/rpi-cpu2mqtt.py \
			 --service"

image:
	docker build --build-arg MYPASSWD=$$PASSWORD --build-arg MQTTPASSWD=$$MQTTPASSWD -t monitor  .


