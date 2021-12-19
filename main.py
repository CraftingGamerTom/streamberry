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
import sys
import psutil
import signal

rtmp_link = os.environ.get('RTMP_LINK')
rtmp_key = os.environ.get('RTMP_KEY')
camera_location = os.environ.get('CAMERA_LOCATION')

def kill(process_pid):
  process = psutil.Process(process_id)
  for proc in process.children(recursive=True):
    proc.kill()
  process.kill()

def runStream(cmd):
#  popen = subprocess.Popen()
#  for stdout_line in iter(popen.stdout.readline, ""):
#    yield stdout_line
#  popen.stdout.close()
#  return_code = popen.wait()
#  if return_code:
#    raise subprocess.CalledProcessError(return_code, cmd)
  popen = subprocess.Popen(cmd)
  for line in popen.stdout:
    print(line.decode(), end='')


# Setup
#tick_seconds = 10
#ticks_per_timecheck = 30 # (10 seconds x 30 = 5 minutes )
#end_stream_time = datetime.now() + timedelta(hours=6) # limit stream time, stop the stream after 6 hours

tick_seconds = 5
ticks_per_timecheck = 6 # (10 seconds x 30 = 5 minutes )
end_stream_time = datetime.now() + timedelta(minutes=1)

print("====================")
print("Starting Live Stream")
print("Time: " + datetime.now().strftime("%d-%b-%Y (%H:%M:%S.%f)"))
print("====================")
sys.stdout.flush()

# Call the shell script for ffmpeg
#process = subprocess.Popen(['sh', './capture.sh', rtmp_link, rtmp_key, camera_location], stdout=subprocess.PIPE, universal_newlines=True)
process = subprocess.Popen(['sh', './capture.sh', rtmp_link, rtmp_key, camera_location], stdout=subprocess.PIPE, shell=True, preexec_fn=os.setsid)

# try:
#   print("waiting")
#   sys.stdout.flush()
#   time.sleep(60)
#   process.wait(timeout=60)
# except subprocess.TimeoutExpired:
#   print("kill")
#   sys.stdout.flush()
#   kill(proc.id)

# Poll process.stdout to show stdout live
#counter_timecheck = 0

# Initial wait
# print("Waiting for FFMPEG to start")
# time.sleep(5)
# print("Begin Checking for output")
# sys.stdout.flush()

# runStream(['sh', './capture.sh', rtmp_link, rtmp_key, camera_location])

#for path in runStream(['sh', './capture.sh', rtmp_link, rtmp_key, camera_location]):
#  print(path, end="")

# Loop, poll for activity
while True:
  # Poll FFMPEG for logs and print them
 output = process.stdout.readline()
 if output == '' and process.poll() is not None:
   break # FFMPEG stopped producing logs, break the loop
 if output:
   print(output.strip())
   sys.stdout.flush()

  ## Check Timecheck Counter (using counter to do time math less often)
#  if counter_timecheck == ticks_per_timecheck:
#    if end_stream_time < datetime.now():
#      break # end the stream, its has been going on for a while
#    counter_timecheck = 0 # stream can keep going, recheck later
#  else:
#    counter_timecheck += 1
    
#  time.sleep(tick_seconds) # sleep, wait for more output from FFMPEG

#rc = process.poll() # Should be 0, not used

time.sleep(60)
os.killpg(os.getpgid(process.pid), signal.SIGTERM)


# print("====================")
# print("Ending Live Stream")
# print("Time: " + datetime.now().strftime("%d-%b-%Y (%H:%M:%S.%f)"))
# print("Image will now close..")
# print("====================")
# sys.stdout.flush()
