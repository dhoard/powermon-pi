#!/bin/bash

# Rudimentary install script, doesn't handle paths with spaces

export POWERMON_PI_DIRECTORY="/opt/powermon-pi"
export POWERMON_PI_ENV="/etc/powermon-pi.env"
export POWERMON_PI_SERVICE="/etc/systemd/system/powermon-pi.service"

WHOAMI=`whoami`

echo "checking we are root"
if [ "${WHOAMI}" != "root" ]
then
  echo "install requires being root"
  exit 1
fi

echo "checking for python3"
command -v python3 >/dev/null 2>&1
if [ ! "$?" == "0" ]
then
  echo "python3 is required"
  exit 1
fi

PYTHON3=`which python3`

echo "checking for ${POWERMON_PI_SERVICE}"
if [ -f "${POWERMON_PI_SERVICE}" ]
then
  echo "stopping powermon-pi"
  systemctl stop powermon > /dev/null 2>&1

  echo "disabling powermon-pi"
  systemctl disable powermon > /dev/null 2>&1
fi

echo "checking for ${POWERMON_PI_DIRECTORY}"
if [ ! -d "${POWERMON_PI_DIRECTORY}" ]
then
  echo "creating ${POWERMON_PI_DIRECTORY}"
  mkdir -p "${POWERMON_PI_DIRECTORY}"
else
  echo "${POWERMON_PI_DIRECTORY} exists"
fi

echo "checking for ${POWERMON_PI_ENV}"
if [ -f "${POWERMON_PI_ENV}" ]
then
  echo "${POWERMON_PI_ENV} exists"
else
  echo "creating default ${POWERMON_PI_ENV}"
  \cp env/powermon-pi.env "${POWERMON_PI_ENV}"
fi

echo "copying src/powermon-pi.sh to ${POWERMON_PI_DIRECTORY}/powermon-pi.sh"
\cp src/powermon-pi.sh "${POWERMON_PI_DIRECTORY}"
chmod u+x "${POWERMON_PI_DIRECTORY}/powermon-pi.sh"

echo "copying src/powermon-pi.fg.sh to ${POWERMON_PI_DIRECTORY}/powermon-pi.fg.sh"
\cp src/powermon-pi.fg.sh "${POWERMON_PI_DIRECTORY}"
chmod u+x "${POWERMON_PI_DIRECTORY}/powermon-pi.fg.sh"

echo "copying src/powermon-pi.py to ${POWERMON_PI_DIRECTORY}/powermon-pi.py"
\cp src/powermon-pi.py "${POWERMON_PI_DIRECTORY}"
chmod ugo-x "${POWERMON_PI_DIRECTORY}/powermon-pi.py"

echo "copying src/powermon-pi.service to /etc/systemd/system/powermon-pi.service"
\cp src/powermon-pi.service /etc/systemd/system/

# Get the path to python3
PYTHON3=`which python3`

# Reload systemd
echo "reloading systemd"
systemctl daemon-reload

echo ""
echo "----"
echo "DONE"
echo "----"
echo ""
echo "Next steps..."
echo ""
echo "1) Edit ${POWERMON_PI_ENV} to change defaults"
echo "2) Enable powermon (systemctl enable powermon-pi.service)"
echo "3) Start powermon (systemctl start powermon-pi.service)"
echo ""
