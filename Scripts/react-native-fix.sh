#!/bin/bash

# Unfortunately Facebook isn't great at making their code compile, so...

# Go to current directory folder so that the script can be called from anywhere
cd "$(dirname "$0")"

function run_sed {
	if [[ $OSTYPE =~ ^darwin ]]
	then
		sed -i '' "$1" $2
	else
		sed -i "$1" $2
	fi
}

react_native_libraries=../node_modules/react-native/Libraries
nodes_manager="${react_native_libraries}/NativeAnimation/RCTNativeAnimatedNodesManager.h"
if [ -e $nodes_manager ]; then
	run_sed 's/#import <RCTAnimation\/RCTValueAnimatedNode.h>/#import "RCTValueAnimatedNode.h"/' $nodes_manager
fi

web_socket="${react_native_libraries}/WebSocket/RCTReconnectingWebSocket.m"
if [ -e $web_socket ]; then
	run_sed 's/#import <fishhook\/fishhook.h>/#import <React\/fishhook.h>/' $web_socket
fi
