#!/bin/bash

TARGET_YARN_VERSION="1.3.2"
YARN_VERSION=$(yarn -v)

echo "yarn version"
echo "current: $YARN_VERSION"
echo "target:  $TARGET_YARN_VERSION"

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

testvercomp () {
    vercomp $1 $2
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ $op != $3 ]]
    then
        return 0
    else
        return 1
    fi
}

testvercomp $YARN_VERSION $TARGET_YARN_VERSION '<'

if [ $? -eq 0 ]
then
  echo "version of yarn is higher than target version - moving on"
else
  echo "version is too low - needs update"
  brew upgrade yarn --without-node
fi
