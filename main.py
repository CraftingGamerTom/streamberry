# RETURN AT THE END

# import subprocess

# process = subprocess.Popen(['sh', './test.sh'], stdout=subprocess.PIPE)
# output, err = process.communicate()
# print(output)




# DOES NOT WORK

# import subprocess
# import sys
# with open('test.log', 'wb') as f: 
#     process = subprocess.Popen(['sh', './test.sh'], stdout=subprocess.PIPE)
#     for c in iter(lambda: process.stdout.read(1), b''): 
#         sys.stdout.buffer.write(c)
#         f.buffer.write(c)




# Imports
from datetime import datetime, timedelta

import subprocess
import time
import os

rtmp_link = os.environ.get('RTMP_LINK')
rtmp_key = os.environ.get('RTMP_KEY')
camera_location = os.environ.get('CAMERA_LOCATION')

# Setup
tick_seconds = 10
ticks_per_timecheck = 30 # (10 seconds x 30 = 5 minutes )
end_stream_time = datetime.now() + timedelta(hours=6) # limit stream time, stop the stream after 6 hours

print("====================")
print("Starting Live Stream")
print("Time: " + datetime.now().strftime("%d-%b-%Y (%H:%M:%S.%f)"))
print("====================")

# Call the shell script for ffmpeg
process = subprocess.Popen(['sh', './capture.sh', rtmp_link, rtmp_key, camera_location], shell=False,stdout=subprocess.PIPE)

# Poll process.stdout to show stdout live
counter_timecheck = 0
while True:
  # Poll FFMPEG for logs and print them
  output = process.stdout.readline()
  if process.poll() is not None:
    break # FFMPEG stopped producing logs, break the loop
  if output:
    print(output.strip())

  ## Check Timecheck Counter (using counter to do time math less often)
  if counter_timecheck == ticks_per_timecheck:
    if end_stream_time < datetime.now():
      break # end the stream, its has been going on for a while
    counter_timecheck = 0 # stream can keep going, recheck later
  else:
    counter_timecheck += 1
    
  time.sleep(tick_seconds) # sleep, wait for more output from FFMPEG

rc = process.poll() # Should be 0, not used

print("====================")
print("Ending Live Stream")
print("Time: " + datetime.now().strftime("%d-%b-%Y (%H:%M:%S.%f)"))
print("Image will now close..")
print("====================")
