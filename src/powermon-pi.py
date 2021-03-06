import os
import sys
import time
import datetime
import RPi.GPIO as GPIO

# Constants
POWER_UP = "POWER UP"
POWER_FAILURE = "POWER FAILURE"

# Debug
def debug(message):
	
	unused = 0
	#log("DEBUG >> " + message)

# Log
def log(message):

	print(str(datetime.datetime.fromtimestamp(time.time())) + " " + message, flush = True)

def write(filename, message, mode):

	f = open(filename, mode)
	f.write(message)
	f.close()

def main(checkIntervalMs, statusFilename):

	log("starting...")
	log("  checkIntervalMs = [" + str(checkIntervalMs) + "]")
	log("  statusFilename = [" + statusFilename + "]")
	
	previousStatus = ""

	GPIO.setmode(GPIO.BOARD)
	INPUT_PIN = 12
	GPIO.setup(INPUT_PIN, GPIO.IN)

	while True:

		debug("checking power...")

		pinValue = GPIO.input(INPUT_PIN)
		
		if pinValue == 0:
	
			currentStatus = POWER_UP

		else:
	
			currentStatus = POWER_FAILURE

		debug("status = [" + currentStatus + "]")
		write("/var/log/powermon-pi.status", str(datetime.datetime.fromtimestamp(time.time())) + " status = [" + currentStatus + "]", "w")  

		if currentStatus != previousStatus:
	
			log("status = [" + currentStatus + "]")
			write(statusFilename, currentStatus, "w")

		previousStatus = currentStatus
		time.sleep(checkIntervalMs / 1000)

if __name__ == '__main__':

	try:

		argumentCount = len(sys.argv)

		if argumentCount != 3:

			log("Usage: python3 " + sys.argv[0] + " <CHECK_INTERVAL_MS> <STATUS_FILENAME>")
			exit(1)

		checkIntervalMs = int(sys.argv[1])
		statusFilename = sys.argv[2]

		main(checkIntervalMs, statusFilename)
	
	except KeyboardInterrupt:

		try:

			sys.exit(0)

		except:

			os._exit(0)


