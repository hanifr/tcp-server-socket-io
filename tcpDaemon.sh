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

echo "${_MAGENTA}Setup Progress....Creating TCP startup service:: started${_RESET}"
echo
sudo cat >/tmp/tcpstart.sh <<EOL
#!/bin/bash

sudo python3 /home/$USER/tcp-server-socket-io/paho.mqtt.python/examples/echo-server.py

EOL

sudo mv /tmp/tcpstart.sh /home/$USER/tcp-server-socket-io/tcpstart.sh
sudo chmod 744 /home/$USER/tcp-server-socket-io/tcpstart.sh
sudo chmod +x /home/$USER/tcp-server-socket-io/tcpstart.sh

# Create daemon service at boot up
sudo cat >/tmp/tcpserver.service <<EOL
[Unit]
Description=TCP-Server
After=syslog.target network.target
[Service]
WorkingDirectory=/home/$USER/tcp-server-socket-io/
ExecStart=/home/$USER/tcp-server-socket-io/tcpstart.sh
Restart=on-failure
KillSignal=SIGINT
# log output to syslog as 'tcp-server'
SyslogIdentifier=tcp-server
#StandardInput = socket
#StandardOutput = socket
StandardError = journal

# non-root user to run as
#WorkingDirectory=/home/$USER/tcp-server-socket-io/

[Install]
WantedBy=multi-user.target
EOL
sudo mv /tmp/tcpserver.service /etc/systemd/system/tcpserver.service
echo "${_YELLOW}[*] Starting loradragino systemd service${_RESET}"
sudo chmod 664 /etc/systemd/system/tcpserver.service
sudo systemctl daemon-reload
sudo systemctl enable tcpserver.service
sudo systemctl start tcpserver.service

echo "${_YELLOW}To see TCP startup service logs run \"sudo journalctl -u tcpserver -f\" command${_RESET}"
echo
echo "${_MAGENTA}Setup Progress....Creating TCP startup service:: finished${_RESET}"
echo

 