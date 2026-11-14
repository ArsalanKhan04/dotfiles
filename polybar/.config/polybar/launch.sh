#!/bin/bash

# Kill any existing polybar instances
killall -q polybar

# Wait for them to fully shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "---" | tee -a /tmp/polybar1.log


polybar bar1 >>/tmp/polybar1.log 2>&1 &
polybar bar2 >>/tmp/polybar2.log 2>&1 &

echo "Polybar launched..."
