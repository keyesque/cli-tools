#!/bin/bash

SERVICE_CMD="sleep 60"
RESTART_COUNT=0

LOG_DIR="$HOME/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/service.log"

# Start the service
$SERVICE_CMD &
PID="$!"

# Cleanup on Ctrl+C
handle_sigint() {
    echo "$(date '+%F %T') - Caught SIGINT. Exiting. Total restarts: $RESTART_COUNT" >> "$LOG_FILE"
    echo "Exiting..."
    exit 0
}
trap handle_sigint SIGINT

echo "$(date '+%F %T') - Watchdog started for PID $PID" >> "$LOG_FILE"

while true; do
    TIMESTAMP=$(date '+%F %T')
    if kill -0 "$PID" 2>/dev/null; then
        echo "$TIMESTAMP - PID $PID is running" >> "$LOG_FILE"

				# Log CPU and memory usage
        USAGE=$(ps -p "$PID" -o %cpu,%mem --no-headers)
        CPU=$(echo $USAGE | awk '{print $1}')
        MEM=$(echo $USAGE | awk '{print $2}')
        echo "$TIMESTAMP - PID $PID CPU: $CPU% MEM: $MEM%" >> "$LOG_FILE"
    else
        echo "$TIMESTAMP - PID $PID is NOT running. Restarting..." >> "$LOG_FILE"
        $SERVICE_CMD &
        PID="$!"
        ((RESTART_COUNT++))
        echo "$TIMESTAMP - Restart count: $RESTART_COUNT" >> "$LOG_FILE"
    fi
    sleep 20
done

# Rotate log
MAX_SIZE=1000
if [ -f "$LOG_FILE" ] && [ $(du -k "$LOG_FILE"| awk '{print $1 }') -ge "$MAX_SIZE" ]; then
	mv "$LOG_FILE" "$LOG_FILE.$(date '+%F_%H-%M-%S')"
	touch "$LOG_FILE"
fi
