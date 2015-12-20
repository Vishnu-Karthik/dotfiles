#!/bin/sh

clock() {
    date '+%H:%M'
}

battery() {
    BATC=/sys/class/power_supply/BAT1/capacity
    BATS=/sys/class/power_supply/BAT1/status

    test "`cat $BATS`" = "Charging" && echo -n '+' || echo -n '-'

    sed -n p $BATC
}

volume() {
    amixer get Master | sed -n 'N;s/^.*\[\([0-9]\+%\).*$/\1/p'
}

cpuload() {
    LINE=`ps -eo pcpu |grep -vE '^\s*(0.0|%CPU)' |sed -n '1h;$!H;$g;s/\n/ +/gp'`
    bc <<< $LINE
}

memused() {
    read t f <<< `grep -E 'Mem(Total|Free)' /proc/meminfo |awk '{print $2}'`
    bc <<< "scale=2; 100 - $f / $t * 100" | cut -d. -f1
}

groups() {
    cur=`xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}'`
    tot=`xprop -root _NET_NUMBER_OF_DESKTOPS | awk '{print $3}'`

    for w in `seq 0 $((cur - 1))`; do line="${line}^i(.config/panel/panel_icons/empty.xbm)"; done
    line="${line}^i(.config/panel/panel_icons/full.xbm)"
    for w in `seq $((cur + 2)) $tot`; do line="${line}^i(.config/panel/panel_icons/empty.xbm)"; done
    echo $line
}

nowplaying() {
    cur=`mpc current`
    test -n "$cur" && echo $cur || echo "- stopped -"
}

while :; do
    buf=""
    buf="${buf} ^pa(10)|^i(.config/panel/panel_icons/music.xbm): $(nowplaying) |"
    buf="${buf} ^pa(658)$(groups) "
    buf="${buf} ^pa(950)|^i(.config/panel/panel_icons/cpu.xbm): $(cpuload)% | "
    buf="${buf} ^i(.config/panel/panel_icons/mem.xbm): $(memused)% | "
    buf="${buf} ^i(.config/panel/panel_icons/bat.xbm): $(battery)% | "
    buf="${buf} ^i(.config/panel/panel_icons/spkr.xbm): $(volume) |"
    buf="${buf} ^i(.config/panel/panel_icons/clock.xbm): $(clock) |"

    echo $buf
    sleep 1 
done
