
#!/bin/bash

PID_FILE="/tmp/disk_monitor.pid"

monitor() {
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    DATE=$(date +"%Y-%m-%d")
    OUTPUT_FILE="disk_usage_$DATE-$TIMESTAMP.csv"

    echo "timestamp,filesystem,used_space,available_space,used_inodes,available_inodes" > $OUTPUT_FILE

    while true; do
        CURRENT_DATE=$(date +"%Y-%m-%d")
        
       
        if [[ "$CURRENT_DATE" != "$DATE" ]]; then
            DATE=$CURRENT_DATE
            TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
            OUTPUT_FILE="disk_usage_$DATE-$TIMESTAMP.csv"
            echo "timestamp,filesystem,used_space,available_space,used_inodes,available_inodes" > $OUTPUT_FILE
        fi
        
        CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")
        
        df -i | awk -v timestamp="$CURRENT_TIME" 'NR>1 {print timestamp "," $1 "," $3 "," $4 "," $5 "," $6}' >> $OUTPUT_FILE

        sleep 60
    done
}

start() {
    if [ -f $PID_FILE ]; then
        echo "Мониторинг уже запущен, PID=$(cat $PID_FILE)"
    else
        monitor &
        echo $! > $PID_FILE
        echo "Мониторинг запущен, PID=$!"
    fi
}

stop() {
    if [ -f $PID_FILE ]; then
        PID=$(cat $PID_FILE)
        kill $PID
        rm -f $PID_FILE
        echo "Мониторинг остановлен, PID=$PID"
    else
        echo "Мониторинг не запущен"
    fi
}

status() {
    if [ -f $PID_FILE ]; then
        PID=$(cat $PID_FILE)
        if ps -p $PID > /dev/null; then
            echo "Мониторинг запущен, PID=$PID"
        else
            echo "Мониторинг не запущен, но PID файл найден"
        fi
    else
        echo "Мониторинг не запущен"
    fi
}

case "$1" in
    START)
        start
        ;;
    STOP)
        stop
        ;;
    STATUS)
        status
        ;;
    *)
        echo "Использование: $0 {START|STOP|STATUS}"
        exit 1
        ;;
esac
