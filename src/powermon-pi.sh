#!/bin/bash

POWERMON_PI_ENV="/etc/powermon-pi.env"
PYTHON3=`which python3`

if [ ! -f "${POWERMON_PI_ENV}" ]; then
  echo "Required ${POWERMON_PI_ENV} not found"
  exit 1
fi

source "${POWERMON_PI_ENV}"

${PYTHON3} powermon-pi.py "${CHECK_INTERVAL_MS}" "${STATUS_FILENAME}" >> "${LOG}" 2>&1
