STEP=2%

show_current() {
    notify-send \
	--urgency=low \
	-h string:x-canonical-private-synchronous:light \
	-h int:value:$(current) \
	--expire-time=1000 \
	"Brightness"
}

current() {
    curr=$(brightnessctl get)
    max=$(brightnessctl max)
    expr $curr \* 100 / $max
}

up() {
    brightnessctl set $STEP+
    show_current
}

down() {
    brightnessctl set $STEP-
    show_current
}

case $1 in
    up) up;;
    down) down;;
    get) current;;
    show) show_current;;
esac
