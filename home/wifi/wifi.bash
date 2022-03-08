notify() {
    notify-send \
	--urgency=low \
	-h string:x-canonical-private-synchronous:wifi \
	--expire-time=1000 \
	"Wifi" \
	$1
}

on() {
    nmcli radio wifi on
    notify "on"
}

off() {
    nmcli radio wifi off
    notify "off"
}

toggle() {
    status=$(nmcli radio wifi)
    if [ "$status" = "enabled" ]; then
	off
    else
	on
    fi
}

status() {
    notify "$(nmcli radio wifi)"
}

case $1 in
    on) on;;
    off) off;;
    toggle) toggle;;
    status) status;;
esac
