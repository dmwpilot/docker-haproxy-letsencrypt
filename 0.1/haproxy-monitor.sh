#!/bin/bash
# start haproxy and allow it to be restarted while making it appear to be in the foreground
# arguments are "haproxy" followed by the arguments to haproxy
# allows us to start something and restart it while keeping the monitor in the foreground
# SIGUSR1 is used as the signal to this process to restart haproxy
# SIGTERM is used to signal haproxy to stop

MYPIDFILE=/var/run/haproxy-monitor.pid
HAPIDFILE=/var/run/haproxy.pid

case "${1:-}" in
    -*|'')
    	echo $$ >$MYPIDFILE
    	trap "rm -f $MYPIDFILE" 0
    	;;
    stop)
    	kill -TERM $(<$MYPIDFILE)
    	if [ $? -ne 0 ]; then
    		echo "Problem sending stop signal, perhaps monitor is not running" >&2
    		exit 1
    	fi
    	exit 0
    	;;
    restart)
    	# there are some hitless methods of doing this, but leaving that for later
    	kill -USR1 $(<$MYPIDFILE)
    	if [ $? -ne 0 ]; then
    		echo "Problem sending stop signal, perhaps monitor is not running" >&2
    		exit 1
    	fi
    	exit 0
    	;;
    *)
    	echo "USAGE:  $0 start|stop|restart haproxy [options]" >&2
    	exit 2
    	;;
esac

trap '
	RESTART=1
	kill -15 $(<$HAPIDFILE)
' SIGUSR1

trap '
	STOP=1
	kill -TERM $(<$HAPIDFILE)
' SIGTERM

RESTART=
STOP=

while :
do
	haproxy -p $HAPIDFILE -W -db "$@"
	if [ -n "$STOP" ]; then
		break
	fi
	if [ -z "$RESTART" ]; then
		echo "Haproxy exited unexpectedly"
		exit 1
	else
		echo "Haproxy restarting"
		RESTART=
	fi
done

echo "Haproxy exited normally"
exit 0

