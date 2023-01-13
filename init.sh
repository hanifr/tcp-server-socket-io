#!/bin/bash
# Colors
_RED=`tput setaf 1`
_GREEN=`tput setaf 2`
_YELLOW=`tput setaf 3`
_BLUE=`tput setaf 4`
_MAGENTA=`tput setaf 5`
_CYAN=`tput setaf 6`
_RESET=`tput sgr0`
# printing greetings

echo "${_MAGENTA}Installation Progress....setup for for TCP server :: started${_RESET}"
echo
sleep 5
chmod +x tcpInit.sh
chmod +x tcpDaemon.sh
echo "${_MAGENTA}Installation Progress....set local time to Kuala Lumpur${_RESET}"
echo
# Installation of Python Dependencies and Libaries
echo "${_MAGENTA}Installation Progress...Installation of Python Dependencies and Libaries${_RESET}"
echo
sudo apt-get install -y python-setuptools

echo "${_MAGENTA}Installation Progress....installation of MQTT PAHO: Started${_RESET}"
echo
git clone https://github.com/eclipse/paho.mqtt.python.git
cd ./paho.mqtt.python
sudo python setup.py install
sleep 5
echo "${_MAGENTA}Installation Progress....installation of MQTT PAHO: Completed${_RESET}"
echo
. tcpInit.sh