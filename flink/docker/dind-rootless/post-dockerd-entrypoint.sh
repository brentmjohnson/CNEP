#!/bin/sh

echo "Running post-dockerd-entrypoint.sh script..."

# enabling job control
echo $(ls -all /dev/tty*)
# setsid sh -c 'exec sh </dev/tty1 >/dev/tty1 2>&1'

# Start the primary process in the background
dockerd-entrypoint.sh $@ &
echo $(jobs)

# Wait for /run/user/9999/docker.pid to exist
while [ ! -f /run/user/9999/docker.pid ]
do
  sleep 1
done

# Run additional commands
socat UNIX-LISTEN:/run/user/9999/beam-worker-pool.sock,fork TCP:localhost:6121 &
nsenter -U --preserve-credentials -n -t $(cat /run/user/9999/docker.pid) -- socat TCP6-LISTEN:6121,reuseaddr,fork /run/user/9999/beam-worker-pool.sock &

# now we bring the primary process back into the foreground
# and leave it there
# fg %1
wait %1