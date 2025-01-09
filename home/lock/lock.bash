TIMEOUT=300

lock() {
    swaylock-fancy -t "Welcome back"
}

lock_on() {
    lock
    swaymsg "output * dpms off"
}

lock_off() {
    swaymsg "output * dpms on"
}

start_idle() {
    swayidle \
	     timeout $TIMEOUT lock_on \
	     resume lock_off \
}
