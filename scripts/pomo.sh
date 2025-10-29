#!/bin/bash

pom_interval=$(( 60 * 50))
pause_interval=$(( 60 * 10 ))
total_sessions=0
is_break=false
prev_length=0

# Flags
auto_start=false

# Check for flag
while getopts "a" opt; do
	case $opt in
		a)
			auto_start=true ;;
	esac
done

# Format time
time_converter(){
	local total_seconds=$1
	local minutes=$(( total_seconds / 60 ))
	local seconds=$(( total_seconds % 60 ))
	printf "%02d:%02d" "$minutes" "$seconds"
}

# Print on same line
print_timer(){
	local message="$1"
	printf "\r%-${prev_length}s"
	printf "\r%s" "$message"
	prev_length=${#message}
	}

# Pomodoro loop
pom_session(){
	time=$pom_interval
	while [ $time -ge 0 ]; do
		print_timer "Work: $(time_converter $time)"
		((time--))
		sleep 1
	done
	(( total_sessions++ ))
	break_session
}
break_session(){
	time=$pause_interval
	while [ $time -ge 0 ]; do
		print_timer "Break: $(time_converter $time)"
		((time--))
		sleep 1
	done

	if [ "$auto_start" = true ]; then
		pom_session
	fi
}

# Menu
while true; do
	echo "POMODORO TIMER"
	echo "--------------"
	echo "Total sessions: $total_sessions"

	echo "What would you like to do?"
	echo "1) Start new session."
	echo "2) Exit."

	read -r key

	case $key in
		1)
			pom_session
			;;
		2)
			echo "Exiting program"
			exit 0
			;;
		*)
			echo "Try again."
			;;
	esac
done
