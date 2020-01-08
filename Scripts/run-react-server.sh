#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FILE_CONTENT="${DIR}/../ZappTvOS/Customization/ApplicationCredentials.swift"
RUN_PACKAGER=0

while IFS='' read -r line || [[ -n "$line" ]]; do
  if [[ $line == *'kReactNativePackagerRoot:String? = "localhost:8081"'* ]]; then
    RUN_PACKAGER=1
    echo "using React Native packager"
  fi
done < ${FILE_CONTENT}

if [[ $RUN_PACKAGER -eq 1 ]]
then
  if nc -w 5 -z localhost 8081;
  then
    echo "packager already running - skipping"
  else
    echo "starting react-native packager"
    open -a Terminal.app "${DIR}/react-native-packager.sh"
  fi
else
  echo "build uses bundled react native - skipping"
fi
