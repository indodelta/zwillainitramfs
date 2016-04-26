#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/bin/test-btn
NAME=test-btn
DESC="Test-btn daemon"
ARGS="/usr/bin/test.sh"

set -e

test -x "$DAEMON" || exit 0

#version 001:
# gpio0_23 = 23 = red LED
# gpio1_13 = 45 = green LED
# gpio1_14  = 46 = recovery key
# gpio0_2  = 2 = test key
#version 000:
# gpio2_5 = 69 = red LED
# gpio2_2 = 66 = green LED

ver=1
if [ "3"x = "$ver"x ]; then
    red_led=71
    green_led=72
elif [ "1"x = "$ver"x ]; then
    red_led=23
    green_led=45
    recover=46
	testbtn=2
else
    red_led=69
    green_led=66
    recover=67
fi

#Recovery 
if [ ! -e /sys/class/gpio/gpio$recover ]; then
	echo $recover > /sys/class/gpio/export
	echo in > /sys/class/gpio/gpio$recover/direction
fi
#Test key
if [ ! -e /sys/class/gpio/gpio$testbtn ]; then
	echo $testbtn > /sys/class/gpio/export
	echo in > /sys/class/gpio/gpio$testbtn/direction
fi
# Green
if [ ! -e /sys/class/gpio/gpio$green_led ]; then
	echo $green_led > /sys/class/gpio/export
fi
	echo out > /sys/class/gpio/gpio$green_led/direction

#Red
if [ ! -e /sys/class/gpio/gpio$red_led ]; then
	echo $red_led > /sys/class/gpio/export
fi	
	echo out > /sys/class/gpio/gpio$red_led/direction

do_start() {
        start-stop-daemon -b -S -x $DAEMON -- $ARGS
}

do_stop() {
        killall -9 $NAME || true
}
case "$1" in
  start)
        echo -n "Starting $DESC: "
	do_start
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
	do_stop
        echo "$NAME."
        ;;
  restart|force-reload)
        echo -n "Restarting $DESC: "
        do_stop
        do_start
        echo "$NAME."
        ;;
  *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac

exit 0
