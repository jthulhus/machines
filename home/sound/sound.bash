STEP='2%'

show_current() {
    notify-send \
	--urgency=low \
	-h string:x-canonical-private-synchronous:sound \
	-h int:value:$(current) \
	--expire-time=1000 \
	"Volume"
}

muted() {
    pactl list sinks | grep '^[[:space:]]Mute:' | tail -1 | awk '{print $2}'
}

show_muted() {
    notify-send \
	--urgency=low \
	-h string:x-canonical-private-synchronous:sound \
	-h int:value:0 \
	--expire-time=1000 \
	"Muted"
}

current() {
    pactl list sinks | grep '^[[:space:]]Volume:' | tail -1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'
}

up() {
    pactl set-sink-volume @DEFAULT_SINK@ +$STEP
    show_current
}

down() {
    pactl set-sink-volume @DEFAULT_SINK@ -$STEP
    show_current
}

mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    if [ "$(muted)" = yes ]; then
	show_muted
    else
	show_current
    fi
}

case $1 in
    up) up;;
    down) down;;
    show) show_current;;
    mute) mute;;
    get) current;;
esac
