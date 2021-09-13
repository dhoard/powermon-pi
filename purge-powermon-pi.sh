#!/bin/bash

# Rudimentary uninstall script, doesn't handle paths with spaces

export POWERMON_PI_DIRECTORY="/opt/powermon-pi"
export POWERMON_PI_ENV="/etc/powermon-pi.env"
export POWERMON_PI_SERVICE="/etc/systemd/system/powermon-pi.service"

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0;;
            [Nn]*) echo "Uninstall aborted" ; exit 0;;
        esac
    done
}

if [ ! "$1" == "--DANGER" ]
then
  echo "Uninstall powermon-pi? THIS WILL REMOVE EVERYTHING"
  yes_or_no
fi

WHOAMI=`whoami`

echo "checking we are root"
if [ "${WHOAMI}" != "root" ]
then
  echo "uninstall requires being root"
  exit 1
fi

echo "checking for ${POWERMON_PI_SERVICE}"
if [ -f "${POWERMON_PI_SERVICE}" ]
then
  echo "stopping powermon-pi"
  systemctl stop powermon > /dev/null 2>&1

  echo "disabling powermon-pi"
  systemctl disable powermon > /dev/null 2>&1
fi

# Reload systemd
echo "reloading systemd"
systemctl daemon-reload

echo "removing ${POWERMON_PI_SERVICE}"
rm -Rf "${POWERMON_PI_SERVICE}"

echo "removing ${POWERMON_PI_ENV}"
rm -Rf "${POWERMON_PI_ENV}"

echo "removing ${POWERMON_PI_DIRECTORY}"
rm -Rf "${POWERMON_PI_DIRECTORY}"

echo "removing /var/log/powermon-pi.log"
rm -Rf /var/log/powermon-pi.log

echo ""
echo "----"
echo "DONE"
echo "----"
