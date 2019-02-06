
riker::declare_command oacurl "Curl with oauth"

OACURL_JAR=/google/src/head/depot/google3/social/mobile/tools/oacurl.jar

riker::subcommand fetch "Fetch a URL"
oacurl::fetch() {
  java -cp $OACURL_JAR com.google.oacurl.Fetch $@
}

riker::subcommand login "Login and obtain OAuth2 credentials"
oacurl::login() {
  java -cp $OACURL_JAR com.google.oacurl.Login $@
}

