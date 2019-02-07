#
# A bunch of useful shortcuts.
#

# Opens all files in a git5 workspace in a sublime project.
subl3() {
  # Behold magic:
  subl $(echo !(blaze*)/)
}

riker::subcommand copres-server "Go to the copres-server dir" go
go::copres-server() {
  cd $CODE_DIR/git5/copres-server/google3
}

c() {
  git add .
  git commit -a -m"snapshot" $*
}

submit() {
   echo "I would normally submit CL $1 now"
   ps -Af
#  g4 submit -c $1
  if [ ! $? ]; then iam "Submitting CL $1"; fi
}


b() {
    blaze $*; notify-send "blaze $* completed"
}

build() {
    b build $*
}

btest() {
    b test $*
}

alias pa="prodaccess -f"

blazerun() {
  /google/src/head/depot/google3/devtools/blaze/scripts/blaze-run.sh $*
}

unalias e
e() {
  emacsclient -t $*
}

trimall() {
  git5 diff --name-only --relative | xargs perl -pi -e 's/[ \t]*$//g'
}

trim() {
   perl -pi -e 's/[ \t]*$//g' $*
}

my_diff() {
  if [ x"$DISPLAY" == x ]; then
    diff $*
  else
    meld $*
  fi
}

si() {
  git5 diff -c 'diff --name-only' | xargs /google/src/head/depot/google3/tools/java/sort_java_imports.py
}

adb_install() {
  adb logcat > /dev/null &
  logcatpid=$!
  adb install -r $1
  kill $logcatpid
}

copres() {
  blaze build java/com/google/social/boq/copresence:boqlet
  ./social/boq/run.sh Copresence
}

copres_stubby() {
  tmpfile=$(mktemp)
  /google/data/ro/projects/tonic/tonicauth --tonic_backend=dev --policy_name=social-copresence-debug --user=testduff@gmail.com --reason=test --datatype_scope=50400 --duration=1h --get_gaia_mint > $tmpfile
  stubby call --deadline=60 http://localhost:9876 $1 --proto2 --rpc_creds_file=$tmpfile --infile=$2
}


install_all() {
  devices=$(adb devices | cut -f1 | grep -v List | awk 'NF > 0')
  for device in $devices; do
    gnome-terminal -e "adb -s $device install -r $*"
  done  
}

logcat_all() {
  devices=$(adb devices | cut -f1 | grep -v List | awk 'NF > 0')
  for device in $devices; do
    gnome-terminal --title="Logcat $device" --window-with-profile=StayOpen -e "logcat-color -s $device"
  done  
}

adb_all() {
  devices=$(adb devices | cut -f1 | grep -v List | awk 'NF > 0')
  for device in $devices; do
    gnome-terminal --title="adb for $device" -e "adb -s $device $*"
  done  
}

adbh() {
  ANDROID_ADB_SERVER_PORT=5039 adb $*
}
