#!/usr/bin/env bash

# Fixed step size
STEP=5

print_error() {
	cmd=$(basename "$0")
	cat <<EOF
    "${cmd}" <action>
    ...valid actions are...
        i -- increase brightness [+5%]
        d -- decrease brightness [-5%]

    Example:
        "${cmd}" i    # Increase brightness by 5%
        "${cmd}" d    # Decrease brightness by 5%
EOF
}

case "$1" in
i | -i) # increase brightness
	brightnessctl --device amdgpu_bl1 set +"$STEP"%
	;;
d | -d) # decrease brightness
	brightnessctl --device amdgpu_bl1 set "$STEP"%-
	;;
*) # invalid usage
	print_error
	;;
esac
