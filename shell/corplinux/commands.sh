#
# A bunch of useful shortcuts.
#

# Opens all files in a git5 workspace in a sublime project.
subl3() {
  # Behold magic:
  subl $(echo !(blaze*)/)
}

riker::subcommand fitness-server "Go to the fitness-server dir" go
go::fitness-server() {
  cd $CODE_DIR/git5/fitness-server/google3
}

riker::subcommand copres-server "Go to the copres-server dir" go
go::copres-server() {
  cd $CODE_DIR/git5/copres-server/google3
}

startoz() {
  now=$(date +"%Y%m%d%H%M%s")
  gnome-terminal --title="Starting Oz in $(pwd)" --geometry=110x34+842+29 -e "apps/people/oz/run.sh --print_logs=no"
  mv -f /usr/local/google/tmp/Oz.STDERR /usr/local/google/tmp/Oz.STDERR.old
  mv -f /usr/local/google/tmp/DevCompilationProxy.STDERR /usr/local/google/tmp/DevCompilationProxy.STDERR.old
  touch /usr/local/google/tmp/Oz.STDERR
  touch /usr/local/google/tmp/DevCompilationProxy.STDERR
  gnome-terminal --title="Oz in $(pwd)" --window-with-profile=Oz --geometry=110x72+66+29 -e "tail -f /usr/local/google/tmp/Oz.STDERR"
  gnome-terminal --title="DevCompilationProxy in $(pwd)" --window-with-profile=DevCompilationProxy --geometry=110x34+841+600 -e "tail -f /usr/local/google/tmp/DevCompilationProxy.STDERR"
  echo "Waiting for oz to start serving..."
  while ! nc -vz localhost 7888; do sleep 1; done
  notify-send -t 10000 "Oz is serving at bduff.mtv:7888"  
}

alias g5='/google/data/ro/projects/shelltoys/g5.sar'

riker::subcommand google3 "Go to the nearest google3 dir" go
go::google3() {
  if [ -d "google3" ]; then
    cd google3
  else
    g3
  fi
}

#
# With no argument: go to the nearest ancestor google3 directory.
# With one argument: go to the google3 directory under the specified
#   perforce client directory (assuming clients are in $HOME/src/clientname)
#
g3() {
  oldpwd=$PWD

  if [ "" != "$1" ]; then
    if [ -d $HOME/src/$1/google3 ]; then
      cd $HOME/src/$1/google3
    else
      if [ -d /usr/local/google/$USER/src/$1/google3 ]; then
         cd /usr/local/google/$USER/src/$1/google3
      else
         echo "No google3 in $HOME/src/$1 or /usr/local/google/$USER/src/$1"
      fi
    fi
  else
    while [ "`basename $PWD`" != "google3" -a "`basename $PWD`" != "/" ]; do
      cd ..
    done
    if [ "`basename $PWD`" = "/" ]; then
      echo "Don't know which google3 dir to go to."
    fi
  fi
}


c() {
  git add .
  git commit -a -m"snapshot" $*
}
intellij() {
  /usr/lib/intellij-idea-7.0/bin/idea.sh
}

submit() {
   echo "I would normally submit CL $1 now"
   ps -Af
#  g4 submit -c $1
  if [ ! $? ]; then iam "Submitting CL $1"; fi
}

forcebuild() {
  touch /home/build/prebuilt/$1/commands/forcebuild
  echo "Requested force build of $1"
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

runoz() {
  blazerun java/com/google/apps/people/oz:server_local_full -- $*
}

mb() {
  magicbuild -a
}

menu() {
  /google/data/ro/projects/menu/menu.par $*
}

si() {
  git5 diff -c 'diff --name-only' | xargs /google/src/head/depot/google3/tools/java/sort_java_imports.py
}

em() {
  EMULATOR="/google/src/head/depot/google3/javatests/com/google/apps/people/oz/testing/integration/mobile/startGplusAndroid.sh --user testduff@gmail.com --password carousel123"
  $EMULATOR $*
}

eml() {
  EMULATOR="javatests/com/google/apps/people/oz/testing/integration/mobile/startGplusAndroid.sh --user testduff@gmail.com --password carousel123"
  $EMULATOR $*
}


emrebuild() {
  blaze build --android_cpu=x86 java/com/google/android/apps/plusone:PlusOne
  adb logcat > /dev/null &
  logcatpid=$!
  adb install -r blaze-bin/java/com/google/android/apps/plusone/PlusOne.apk
  kill $logcatpid
  adb shell am start -n com.google.android.apps.plus/.phone.HomeActivity
}

mdeploy() {
  blaze build java/com/google/android/apps/plusone:PlusOne
  adb logcat > /dev/null &
  logcatpid=$!
  adb install -r blaze-bin/java/com/google/android/apps/plusone/PlusOne.apk
  kill $logcatpid
  adb shell am start -n com.google.android.apps.plus/.phone.HomeActivity
}

pdeploy() {
  blaze build --android_cpu=x86 java/com/google/android/apps/plusone/experiments/protos:PlusOne
  adb logcat > /dev/null &
  logcatpid=$!
  adb install -r blaze-bin/java/com/google/android/apps/plusone/experiments/protos/PlusOne.apk
  kill $logcatpid
  adb shell am start -n com.google.android.apps.plus/.phone.HomeActivity
}

crow() {
  /google/data/ro/teams/mobile_eng_prod/crow/crow.par --device nexus_4 --proxy None --google_addons --arch x86 --api_level 17 -- --enable_open_gl
  adb wait-for-device
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

knife_clean() {
  /home/murali/knife/build_cleaner --action_spec=fix_deps:java_* --action_spec=add_missing_rules --action_spec=buildify $*
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
