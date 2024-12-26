
# Remove Docker Container
clean:
	-docker rm -f monitor

# Run the Image with default CMD Statement
monitor: test_on_env
	docker run -d \
		--hostname FROM-$(shell hostname) \
		--restart unless-stopped \
		--name monitor \
		-v ./$(MYCONFIG):/home/monitor/rpi-mqtt-monitor/src/config.py:ro \
		monitor

# Run the Image with explicit CMD Statement
monitor_cmd: test_on_env
	docker run -d \
		--hostname FROM-$(shell hostname) \
		--restart unless-stopped \
		--name monitor \
		--user monitor \
		-v $${PWD}/$(MYCONFIG):rpi_mon_env/src/config.py \
		monitor sh -c \
			"cd /rpi-mqtt-monitor; \
			 rpi-mqtt-monitor/rpi_mon_env/bin/python3 \
			 rpi-mqtt-monitor/src/rpi-cpu2mqtt.py \
			 --service"

test_on_env:
	@if test -z "$(MYCONFIG)"; then \
		echo "Error: Environment variable MYCONFIG is not set."; \
		echo "Usage MYCONFIG=<My local config file> make monitor"; \
		echo "	or export MYCONFIG=<My local config file> && make monitor"; \
		exit 1; \
	fi

# Create Image
image:
	docker build --build-arg MYPASSWD=$$PASSWORD --build-arg MQTTPASSWD=$$MQTTPASSWD -t monitor  .

# Create config file to be mounted in Container at runtime.
# Base file is a specific config file, pointed to by $(MYCONFIG).
config: config.py
	@echo "done."

config.py: FORCE
	@if test -z "$(MYCONFIG)"; then \
		echo "Error: Environment variable MYCONFIG is not set."; \
		exit 2; \
	fi
	@if test -z "$(MQTTPASS)"; then \
		echo "Error: Environment variable MQTTPASS is not set."; \
		exit 3; \
	fi
	@if test -z "$(MQTTHOST)"; then \
		echo "Error: Environment variable MQTTHOST is not set."; \
		exit 4; \
	fi
	@if test -z "$(MQTTPORT)"; then \
		echo -n "Info: Environment variable MQTTPORT not set. "; \
		echo "Use default value 1883."; \
		MQTTPORT=1883; \
	fi
	@if test -z "$(MQTTUSER)"; then \
		echo -n "Info: Environment variable MQTTUSER not set. "; \
		echo "Use default value 'mqttmonitor'."; \
		MQTTUSER=mqttmonitor; \
	fi

	@# Concat the config.py from 
	@#   1. the prepared head part of src/config.py
	@#   2. the tail part of $(MYCONFIG) with manually set infos
	@grep -B 999 "# This part is NOT patched" src/config.py > config.py
	@grep -A 999 "# This part is NOT patched" config_Balin.py | tail -n +2 >> config.py
	
	@# Change Placeholders against current ENV vars
	@sed -i s/MQTTPASS/$(MQTTPASS)/ config.py
	@sed -i s/MQTTHOST/$(MQTTHOST)/ config.py
	@sed -i s/MQTTPORT/$(MQTTPORT)/ config.py
	@sed -i s/MQTTUSER/$(MQTTUSER)/ config.py

	# Show result
	@grep -B 999 "# This part is NOT patched" config.py

.PHONY: FORCE
