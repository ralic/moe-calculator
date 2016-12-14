#!/bin/bash

# Check directories set by xcconfigs
if [ ! -d "$MOE_PROJECT_DIR" ]; then
    echo "$0:$LINENO:1: error: 'MOE_PROJECT_DIR' doesn't point to a directory!"; exit 1;
fi
if [ ! -d "$MOE_PROJECT_BUILD_DIR" ]; then
    echo "$0:$LINENO:1: error: 'MOE_PROJECT_BUILD_DIR' doesn't point to a directory!"; exit 1;
fi

cd "$MOE_PROJECT_DIR/"

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
java -version

########################
# Find Gradle
########################
function findGradle {
	CD="$PWD"
	while [ "$CD" != "" ]; do
		echo "Looking for gradlew in $CD"
		if [ -x "$CD/gradlew" ]; then
			GRADLE_EXEC=$CD/gradlew
			return 0
		fi
		CD="${CD%/*}"
	done

	echo "Checking with 'which'"
	GRADLE_EXEC=$(which 'gradle')

	if [ "$GRADLE_EXEC" = "" ]; then
		echo "Failed to locate 'gradle' executable!"
		exit 1
	fi
}
########################
# Execute Gradle build
########################
if [ -z "$MOE_GRADLE_EXTERNAL_BUILD" ]; then
    findGradle

    "$GRADLE_EXEC" --daemon moeXcodeInternal
fi

