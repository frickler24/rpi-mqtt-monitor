from random import randrange

# Script version
version = '1.1.2'

# MQTT server configuration
mqtt_host = "frickler.duckdns.org"
mqtt_user = "mqttmonitor"
mqtt_password = "Broadcast-Unproportional-Kdebugrc-Geschichtsschreibung-Drehzahl-Vierdecker-Aufstand-Schwache"
mqtt_port = "1883"
mqtt_discovery_prefix = "homeassistant"
mqtt_topic_prefix = "rpi-MQTT-monitor"

# Retain flag for published topics
retain = True

# QOS setting for published topics: 0,1,2 are acceptable values
qos = 0

# Home Assistant API configuration
hass_token = "your_hass_token"
hass_host = "your_hass_host"

# Messages configuration

# Interval in seconds between probes when running the script as a service (--service option)
service_sleep_time = 10

# Interval for checking git_update and apt_updates
update_check_interval = 3600 # 1 hour

# Random delay in seconds before taking probes
# - this is used for de-synchronizing message if you run this script on many hosts.
# - if you want a fixed delay you can remove the randrange function and just set the needed value.
# random_delay = randrange(10)

# Uncomment the line bellow to send just one CSV message containing all values (this method don't support HA discovery_messages)
# group_messages = True

# If this is set, then the script will send MQTT discovery messages meaning a config less setup in HA.
# Only works when group_messages is not used
discovery_messages = True

# System control configuration

# Enable remote restart button in Home Assistant
restart_button = True

# Enable remote shutdown button in Home Assistant
shutdown_button = True

# Enable remote update of the script via Home Assistant
update = True

# Enable control of attached display(s) via Home Assistant
display_control = False

# user for which display_control is enabled
os_user = 'root'

# By default, the 'hostname' will be used as device name in home assistant.
# To set a custom device name, uncomment the following line and set the custom name.
# ha_device_name = 'device_name_to_use'

# Sensors configuration

# Binary sensor that displays when there is an update for the script
git_update = True

cpu_load = True
cpu_temp = True
used_space = True
used_space_path = '/'
voltage = False
sys_clock_speed = False
swap = False
memory = True
uptime = True
uptime_seconds = False

# Check storage devices temperatures - experimental feature, disabled by default
drive_temps = False

# Enable wifi_signal for unit of measuring % or wifi_signal_dbm for unit of meaning dBm
wifi_signal = False
wifi_signal_dbm = False

# This works only on raspbery pi version 5 with stock fan
rpi5_fan_speed = False

# this works only on raspbery pi
rpi_power_status = False

# Check for apt updates - experimental feature, disabled by default, updated with update_check_interval
apt_updates = False

# Change the thermal zone if you have issues with cpu temps
cpu_thermal_zone = 'cpu'

# read external sensors for temperature, humidity, pressure etc.
ext_sensors = False
#ext_sensors = [["Housing", "ds18b20", "0014531448ff", -300], ["ext2", "sht21", 0, [-300, 0]]] 

# output file
output_filename = False
#output_filename = "/dev/shm/mjpeg/user_annotate.txt"
# a for append or w for write (overwrites content)
output_mode = "w"
# define what should be in the output
def get_content_outputfile():
    # In this example the values from the ext_sensors are used
    # the values for the temperature values are rounded to 1 decimal
    sht21_temp = round(float(ext_sensors[1][3][0]), 1) 
    sht21_hum = ext_sensors[1][3][1] 
    ds18b20_temp = round(float(ext_sensors[0][3]), 1) 
    return f"T: {sht21_temp} 'C; H: {sht21_hum} %% ; T-Rpi: {ds18b20_temp} 'C"

