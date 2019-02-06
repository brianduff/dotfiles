# Commands for corp laptop.

describe mountcode "Mounts ${CODE_DIR} on the local ssh tunnel at ${MOUNTED_CODE_DIR}. --notunnel for miao."
mountcode() {
  local host=127.0.0.1
  local port="-p {SSH_TUNNEL_PORT}"
  if [[] "$1" == "--notunnel" ]]; then
    host="miao.mtv.corp.google.com"
    port=""
  fi
  unmountcode
  mkdir ${MOUNTED_CODE_DIR}
  sshfs -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no bduff@${host}:${CODE_DIR} ${MOUNTED_CODE_DIR} ${port}
}

describe unmountcode "Unmounts ${MOUNTED_CODE_DIR}"
unmountcode() {
  diskutil unmount force ${MOUNTED_CODE_DIR}
  rm -f ${MOUNTED_CODE_DIR}
}

describe ssht "Opens an ssh connection to the ssh tunnel on localhost:${SSH_TUNNEL_PORT}"
ssht() {
  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no bduff@127.0.0.1 -p ${SSH_TUNNEL_PORT}
}

describe mountandroid "Mounts the android sparseimage"
mountandroid() {
  hdiutil attach ~/Documents/android.dmg.sparseimage -mountpoint ~/Documents/code/android
}
