#### I have to validate if ARTIFACT_URL is available

if [ -n "$ARTIFACT_URL" ]
then
  echo "========================================="
  echo "Download artifact"
  echo "========================================="

  file=`basename "$ARTIFACT_URL"`
  wget -q --no-check-certificate --connect-timeout=5 --read-timeout=10 --tries=2 -O "/tmp/$file" "$ARTIFACT_URL"

  #### I have to unpackage the file to $APP_HOME

  if [ $? -eq 0 ]
  then

    if [[ $ARTIFACT_URL = *.tgz* ]]
    then
       tar -xzvf /tmp/$file -C "$APP_HOME"
    fi
    if [[ $ARTIFACT_URL = *.zip* ]]
    then
       unzip  /tmp/$file  -d "$APP_HOME"
    fi
    if [[ $ARTIFACT_URL = *.jar* ]]
    then
       cp /tmp/$file "$APP_HOME"
    fi
	if [[ $ARTIFACT_URL = *.war* ]]
    then
       cp /tmp/$file "$APP_HOME"
    fi
  else
    echo "ERROR: while Downloading file from $ARTIFACT_URL"
    return 1
  fi
fi