#!/usr/bin/env bash
###############################################################################
#
#	gitupdate.sh
#
#	- 	iterates over each subdirectory of current path
#		if it contains a .git subfolder then performs:
#			- git fetch
#			- git status
#		based on git status result displays colored status line
#		if the repo needs pull/add/commit/... it displays git output
#
###############################################################################
#
#	colorful colors, yay...
#
readonly COLOR_OFF='\033[0m'
readonly COLOR_LIGHT_RED='\033[1;31m'
readonly COLOR_LIGHT_GREEN='\033[1;32m'
readonly COLOR_LIGHT_YELLOW='\033[1;33m'
readonly COLOR_DARK_RED='\033[0;31m'
readonly COLOR_DARK_GREEN='\033[0;32m'
readonly COLOR_DARK_YELLOW='\033[0;33m'
readonly COLOR_REV_RED='\033[7;31m'
readonly COLOR_REV_GREEN='\033[7;32m'
readonly COLOR_REV_YELLOW='\033[7;33m'
#
#	main loop
#
for DIR in */.git
do
	# just the dir name
	DIR="${DIR%%/*}"
	# formatted [dir name]
	printf -v TAG "[%-30.30s]" "$DIR"
	# subshell
	(
		EXTRA=
		# let's move into
		cd "$DIR"
		# do we have remotes?
		[ "$(git remote -v)" != "" ] && {
			# yes, then we fetch
			git fetch > /dev/null
		} || {
			# no, we dont
			#EXTRA="${COLOR_REV_RED}* no remotes available * ${COLOR_OFF}"
			printf -v EXTRA "[%-25.25s]" "no remotes available"
		}
		# git output
		STATUS="$(git status 2>&1 )"
		# git exit code
		GITEXIT=$?
		#
		#	everyithing ok
		#
		[ $GITEXIT -eq 0 ] && {
			#
			#	ok, nothing to do
			#
			#egrep -qiz '(On branch.*)(Your branch is up-to-date with.*)*nothing to commit, working tree clean' <<< "$STATUS" && {
			#git status |  tr $'\n' ' ' | egrep -i "(On branch [^[:space:]]+)[[:space:]]+(your branch is up to date with '[^']+'\.)[[:space:]]+(nothing to commit, working tree clean)"
			regex="(On branch [^[:space:]]+)[[:space:]]+"
			regex="${regex}(your branch is up[ -]to[ -]date with '[^']+'\.[[:space:]]+)*"
			regex="${regex}(nothing to commit, working tree clean)"
			
			git status | tr $'\n' ' ' | egrep -qi "$regex" && {
				printf "$TAG	${COLOR_REV_GREEN}%-25.25s${COLOR_OFF}${EXTRA}\n" "ok"
				#echo "$STATUS"
				#git status
			} || {
				#
				#	something to do
				#
				printf "$TAG	${COLOR_REV_YELLOW}%-25.25s${COLOR_OFF}${EXTRA}\n" "check messages"
				echo "----------------------------------------------------------------------------"
				git status
				echo "----------------------------------------------------------------------------"
			}
		} || {
			#
			#	ERROR!!!!
			#
			printf "$TAG	${COLOR_REV_RED}%-25.25s${COLOR_OFF}${EXTRA}\n" "something's wrong"
			echo "----------------------------------------------------------------------------"
			git status
			echo "----------------------------------------------------------------------------"
		}
	)
	#
	#	end subshell, nothing happened
	#
done

