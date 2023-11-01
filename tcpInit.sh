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

echo "${_MAGENTA}Setup Progress....TCP configuration :: started${_RESET}"
echo
# setting up TCP service
sleep 5
echo "${_CYAN}Please Enter the TCP IP Address${_RESET} $_host"
                read -p "Enter the TCP IP_Address: " _host
echo
echo "${_CYAN}Please Enter the TCP port to publish data${_RESET} $_port"
                read -p "Enter the TCP port: " _port
echo "${_CYAN}Please Enter the MQTT domain_name${_RESET} $_domain"
                read -p "Enter the MQTT domain_name: " _domain
echo
echo "${_CYAN}Please Enter the MQTT topic to publish data${_RESET} $_topic"
                read -p "Enter the MQTT topic_name: " _topic
sudo cat >/tmp/echo-server.py <<EOL
#!/usr/bin/python
# -*- coding: utf-8 -*-

# M. H. M. Ramli
#  SEA-IC, UiTM Shah Alam
#  Please report if there is any bugs in the program :: tronexia@gmail.com

#  Program: TCP Server listener and broadcast publicly all received data via MQTT

# This shows an example of using the publish.single helper function.

import context  # Ensures paho is in PYTHONPATH
import socket
import sys
import string
import random

# import paho.mqtt.publish as publish

HOST = "$_host"  # The server's hostname or IP address
PORT = $_port  # The port used by the server

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port

server_address = (HOST, PORT)
print("Start TCP Listening from", HOST)
s.bind(server_address)

# Listen for incoming connections

s.listen(1)

while True:

    # Wait for a connection

    print("waiting for a connection")
    (connection, client_address) = s.accept()
    try:
        print("connection from", client_address)

        # Receive the data in small chunks and retransmit it

        while True:
            data = connection.recv(4096)
            print('received "%s"' % data, file=sys.stderr)
            publish.single("$_topic", data, hostname="$_domain")
            if data:
                print("sending data back to the client", file=sys.stderr)
                connection.sendall(b'\x01')
            else:
                print("no more data from", client_address, file=sys.stderr)
                break
    finally:

        # Clean up the connection

        connection.close()

EOL
sudo mv /tmp/echo-server.py   /home/$USER/tcp-server-socket-io/paho.mqtt.python/examples/echo-server.py
sleep 5
sudo apt-get update
sleep 5
sudo ufw allow $_port/tcp

sudo chmod +x /home/$USER/paho.mqtt.python/examples/echo-server.py
echo "${_MAGENTA}Setup Progress....TCP configuration :: finished${_RESET}"
echo
. tcpDaemon.sh
