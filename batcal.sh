#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)

__0_ac="/sys/class/power_supply/AC"
__1_min_voltage=9.6
__2_max_voltage=12.6
function err__0_v0 {
    local stuff=$1
            gum log -l error "${stuff}"
__AS=$?
}
function fatal__1_v0 {
    local stuff=$1
            gum log -l fatal "${stuff}"
__AS=$?
}
function info__2_v0 {
    local stuff=$1
            gum log -l info  "${stuff}"
__AS=$?
}
function warn__3_v0 {
    local stuff=$1
            gum log -l warn  "${stuff}"
__AS=$?
}
function get_voltage__4_v0 {
    local battery=$1
    __AMBER_VAL_0=$(cat ${battery}/voltage_now);
    __AS=$?;
    __AF_get_voltage4_v0=$(echo "${__AMBER_VAL_0}" '/' 1000000 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
function get_status__5_v0 {
    local battery=$1
    __AMBER_VAL_1=$(cat ${battery}/status);
    __AS=$?;
    __AF_get_status5_v0="${__AMBER_VAL_1}";
    return 0
}
function actual_stats__6_v0 {
    local battery=$1
    __AMBER_VAL_2=$(cat ${battery}/status);
    __AS=$?;
    local state="${__AMBER_VAL_2}"
    __AMBER_VAL_3=$(cat ${battery}/energy_now);
    __AS=$?;
    local energy_now=$(echo "${__AMBER_VAL_3}" '/' 1000000 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __AMBER_VAL_4=$(cat ${battery}/energy_full);
    __AS=$?;
    local energy_full=$(echo "${__AMBER_VAL_4}" '/' 1000000 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __AMBER_VAL_5=$(cat ${battery}/energy_full_design);
    __AS=$?;
    local energy_full_design=$(echo "${__AMBER_VAL_5}" '/' 1000000 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    get_voltage__4_v0 "${battery}";
    __AF_get_voltage4_v0__23=$__AF_get_voltage4_v0;
    local voltage_now=$__AF_get_voltage4_v0__23
    __AMBER_VAL_6=$(cat ${battery}/capacity);
    __AS=$?;
    local capacity="${__AMBER_VAL_6}"
    __AMBER_VAL_7=$(cat ${battery}/charge_behaviour);
    __AS=$?;
    local charge_behaviour="${__AMBER_VAL_7}"
    echo "	Status: ${state}      "
    echo "	Capacity: ${capacity}      "
    echo "	Charge behaviour: ${charge_behaviour}      "
    echo "	Energy stored: ${energy_now} Wh      "
    echo "	Energy full/design: ${energy_full}/${energy_full_design} Wh      "
    echo "	Voltage now: ${voltage_now} V      "
}
function print_stats__7_v0 {
    local battery=$1
    __AMBER_VAL_8=$(echo ${battery} | rev | cut -d '/' -f 1 | rev);
    __AS=$?;
    local bat_name="${__AMBER_VAL_8}"
    info__2_v0 "Current stats of ${bat_name} (as seen by the bms):";
    __AF_info2_v0__38=$__AF_info2_v0;
    echo $__AF_info2_v0__38 > /dev/null 2>&1
    actual_stats__6_v0 "${battery}";
    __AF_actual_stats6_v0__39=$__AF_actual_stats6_v0;
    echo $__AF_actual_stats6_v0__39 > /dev/null 2>&1
}
function redraw_stats__8_v0 {
    local battery=$1
            tput cuu 6
__AS=$?
    actual_stats__6_v0 "${battery}";
    __AF_actual_stats6_v0__44=$__AF_actual_stats6_v0;
    echo $__AF_actual_stats6_v0__44 > /dev/null 2>&1
}
function detect_ac__9_v0 {
            ls "${__0_ac}" > /dev/null 2>&1
__AS=$?;
if [ $__AS != 0 ]; then
            warn__3_v0 "Can't find the laptop's power supply directory. Please, specify manually." > /dev/null 2>&1;
            __AF_warn3_v0__49=$__AF_warn3_v0;
            echo $__AF_warn3_v0__49 > /dev/null 2>&1
            __AMBER_VAL_9=$(gum choose /sys/class/power_supply/*);
            __AS=$?;
            __0_ac="${__AMBER_VAL_9}"
fi
    __AMBER_VAL_10=$(cat ${__0_ac}/online);
    __AS=$?;
if [ $__AS != 0 ]; then
        err__0_v0 "${__0_ac}/online is not present or inaccessible";
        __AF_err0_v0__54=$__AF_err0_v0;
        echo $__AF_err0_v0__54 > /dev/null 2>&1
fi;
    local online="${__AMBER_VAL_10}"
    if [ $([ "_${online}" != "_0" ]; echo $?) != 0 ]; then
        err__0_v0 "Power supply not connected. Connect it and try again";
        __AF_err0_v0__59=$__AF_err0_v0;
        echo $__AF_err0_v0__59 > /dev/null 2>&1
        __AF_detect_ac9_v0='';
        return 1
fi
}
function set_charge_behaviour__10_v0 {
    local charge_behaviour=$1
    local battery=$2
    info__2_v0 "Setting charge_behaviour to ${charge_behaviour}";
    __AF_info2_v0__65=$__AF_info2_v0;
    echo $__AF_info2_v0__65 > /dev/null 2>&1
    echo "${charge_behaviour}" > ${battery}/charge_behaviour
__AS=$?;
if [ $__AS != 0 ]; then
__AF_set_charge_behaviour10_v0=''
return $__AS
fi
}
function charge_cycle__11_v0 {
    local battery=$1
    info__2_v0 "Started charge cycle.";
    __AF_info2_v0__71=$__AF_info2_v0;
    echo $__AF_info2_v0__71 > /dev/null 2>&1
            set_charge_behaviour__10_v0 "auto" "${battery}";
        __AS=$?;
        __AF_set_charge_behaviour10_v0__72=$__AF_set_charge_behaviour10_v0;
        echo $__AF_set_charge_behaviour10_v0__72 > /dev/null 2>&1
    print_stats__7_v0 "${battery}";
    __AF_print_stats7_v0__73=$__AF_print_stats7_v0;
    echo $__AF_print_stats7_v0__73 > /dev/null 2>&1
    while :
do
        get_voltage__4_v0 "${battery}";
        __AF_get_voltage4_v0__75=$__AF_get_voltage4_v0;
        get_status__5_v0 "${battery}";
        __AF_get_status5_v0__75="${__AF_get_status5_v0}";
        get_status__5_v0 "${battery}";
        __AF_get_status5_v0__75="${__AF_get_status5_v0}";
        if [ $(echo $(echo $__AF_get_voltage4_v0__75 '>=' ${__2_max_voltage} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '||' $(echo $([ "_${__AF_get_status5_v0__75}" != "_Not charging" ]; echo $?) '||' $([ "_${__AF_get_status5_v0__75}" != "_Full" ]; echo $?) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            info__2_v0 "Battery voltage reached ${__2_max_voltage}, stopping charge cycle.";
            __AF_info2_v0__76=$__AF_info2_v0;
            echo $__AF_info2_v0__76 > /dev/null 2>&1
                            set_charge_behaviour__10_v0 "inhibit-charge" "${battery}";
                __AS=$?;
                __AF_set_charge_behaviour10_v0__77=$__AF_set_charge_behaviour10_v0;
                echo $__AF_set_charge_behaviour10_v0__77 > /dev/null 2>&1
            break
fi
                    sleep 5
__AS=$?
        redraw_stats__8_v0 "${battery}";
        __AF_redraw_stats8_v0__81=$__AF_redraw_stats8_v0;
        echo $__AF_redraw_stats8_v0__81 > /dev/null 2>&1
done
}
function discharge_cycle__12_v0 {
    local battery=$1
    info__2_v0 "Started charge cycle.";
    __AF_info2_v0__87=$__AF_info2_v0;
    echo $__AF_info2_v0__87 > /dev/null 2>&1
            set_charge_behaviour__10_v0 "force-discharge" "${battery}";
        __AS=$?;
        __AF_set_charge_behaviour10_v0__88=$__AF_set_charge_behaviour10_v0;
        echo $__AF_set_charge_behaviour10_v0__88 > /dev/null 2>&1
    __AMBER_VAL_11=$(stress-ng --cpu 8 --cpu-method matrixprod --metrics-brief --perf &>/dev/null & echo $! );
    __AS=$?;
    local pid="${__AMBER_VAL_11}"
    print_stats__7_v0 "${battery}";
    __AF_print_stats7_v0__91=$__AF_print_stats7_v0;
    echo $__AF_print_stats7_v0__91 > /dev/null 2>&1
    while :
do
        get_voltage__4_v0 "${battery}";
        __AF_get_voltage4_v0__93=$__AF_get_voltage4_v0;
        if [ $(echo $__AF_get_voltage4_v0__93 '<=' ${__1_min_voltage} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            info__2_v0 "Battery voltage reached ${__1_min_voltage}, stopping discharge cycle.";
            __AF_info2_v0__94=$__AF_info2_v0;
            echo $__AF_info2_v0__94 > /dev/null 2>&1
                            kill ${pid}
__AS=$?
            break
fi
                    sleep 5
__AS=$?
        redraw_stats__8_v0 "${battery}";
        __AF_redraw_stats8_v0__99=$__AF_redraw_stats8_v0;
        echo $__AF_redraw_stats8_v0__99 > /dev/null 2>&1
done
}

    gum log -l info "Availeable batteries:"
__AS=$?;
if [ $__AS != 0 ]; then
        echo "Seems like gum is not installed. Make sure it is and try again."
        exit 1
fi
    __AMBER_VAL_12=$(gum choose --select-if-one /sys/class/power_supply/BAT*);
    __AS=$?;
    battery="${__AMBER_VAL_12}"
    print_stats__7_v0 "${battery}";
    __AF_print_stats7_v0__110=$__AF_print_stats7_v0;
    echo $__AF_print_stats7_v0__110 > /dev/null 2>&1
    __AMBER_VAL_13=$(gum choose 2 3 4 --header "How many sequential cells does the battery have:");
    __AS=$?;
    battery_cells="${__AMBER_VAL_13}"
    __1_min_voltage=$(echo $(echo 3.2 '*' ${battery_cells} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' 0.1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __2_max_voltage=$(echo $(echo 4.2 '*' ${battery_cells} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '+' 0.1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    info__2_v0 "Discharging down to ${__1_min_voltage}";
    __AF_info2_v0__115=$__AF_info2_v0;
    echo $__AF_info2_v0__115 > /dev/null 2>&1
    info__2_v0 "Charging up to ${__2_max_voltage}";
    __AF_info2_v0__116=$__AF_info2_v0;
    echo $__AF_info2_v0__116 > /dev/null 2>&1
    exit 1
    set_charge_behaviour__10_v0 "auto" "${battery}";
    __AS=$?;
if [ $__AS != 0 ]; then
        fatal__1_v0 "Can't write to ${battery}/charge_behaviour. I suggest re-running the script with root privilleges (sudo).";
        __AF_fatal1_v0__120=$__AF_fatal1_v0;
        echo $__AF_fatal1_v0__120 > /dev/null 2>&1
        exit 1
fi;
    __AF_set_charge_behaviour10_v0__119=$__AF_set_charge_behaviour10_v0;
    echo $__AF_set_charge_behaviour10_v0__119 > /dev/null 2>&1
    has_sysd=1
            which systemctl
__AS=$?;
if [ $__AS != 0 ]; then
                            gum confirm --affirmative="Ok" --negative="" "Seem to be running on a non-systemd distro. Stop upower if you're using it and press ok"
__AS=$?
            has_sysd=0
fi
    if [ ${has_sysd} != 0 ]; then
        has_upower=1
                    systemctl list-unit-files | grep upower > /dev/null 2>&1
__AS=$?;
if [ $__AS != 0 ]; then
                has_upower=0
fi
        if [ ${has_upower} != 0 ]; then
            info__2_v0 "Detected upower. Stopping it.";
            __AF_info2_v0__136=$__AF_info2_v0;
            echo $__AF_info2_v0__136 > /dev/null 2>&1
                            systemctl stop upower
__AS=$?
fi
fi
    detect_ac__9_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then

exit $__AS
fi;
    __AF_detect_ac9_v0__141=$__AF_detect_ac9_v0;
    echo $__AF_detect_ac9_v0__141 > /dev/null 2>&1
            gum confirm --affirmative="Ok" --negative="" "About to start cycling the battery. The process is infinite, you can Ctrl-c at any moment."
__AS=$?
    gum confirm "Go straight to discharge cycle?"
__AS=$?;
if [ $__AS != 0 ]; then
        charge_cycle__11_v0 "${battery}";
        __AF_charge_cycle11_v0__146=$__AF_charge_cycle11_v0;
        echo $__AF_charge_cycle11_v0__146 > /dev/null 2>&1
fi
    while :
do
        discharge_cycle__12_v0 "${battery}";
        __AF_discharge_cycle12_v0__150=$__AF_discharge_cycle12_v0;
        echo $__AF_discharge_cycle12_v0__150 > /dev/null 2>&1
        charge_cycle__11_v0 "${battery}";
        __AF_charge_cycle11_v0__151=$__AF_charge_cycle11_v0;
        echo $__AF_charge_cycle11_v0__151 > /dev/null 2>&1
done