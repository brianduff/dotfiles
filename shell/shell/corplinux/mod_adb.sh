
ad() {
  declare -A known_devices
  known_devices[shamu]=NP5A340520
  known_devices[n5c]=0736c3da0ac9b11d
  known_devices[n4]=04d06832cbded7a3

  if [ "$1" == "-a" ]; then
    devices=$(adb devices | cut -f1 | grep -v "devices" | sed '/^$/d')
    shift 1
    for device in $devices; do
      adb -s $device $*
    done
  else
    local serial=${known_devices[$1]}
    if [ "$serial" != "" ]; then
      shift 1
      adb -s $serial $*
    else
      adb $*
    fi
  fi
}
