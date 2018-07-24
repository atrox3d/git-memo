#!/usr/bin/env bash

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

#echo -e "${LIGHT_GREEN}light green"
#echo -e "${DARK_GREEN}dark green"
#echo -e "${COLOR_OFF}"

for DIR in */.git
do
	DIR="${DIR%%/*}"
	printf -v TAG "[%-30.30s]" "$DIR"
	#echo "##################################################"
	#echo "$TAG"
	#echo "##################################################"
	(
		cd "$DIR"
		[ "$(git remote -v)" != "" ] && {
			#echo "$TAG	fetching..."
			git fetch
		} || {
			echo -e "$TAG	${COLOR_REV_RED}*** no remotes available ***${COLOR_OFF}"
		}
		#echo "--------------------------------------------------"
		#echo "$TAG	[STATUS]"
		#echo "--------------------------------------------------"
		STATUS="$(git status)"
		GITEXIT=$?
		#git status
		#echo
		[ $GITEXIT -eq 0 ] && {
			egrep -qiz '(On branch.*)(Your branch is up-to-date with.*)*nothing to commit, working tree clean' <<< "$STATUS" && {
				#echo -e "$TAG	${COLOR_REV_GREEN}ok${COLOR_OFF}"
				printf "$TAG	${COLOR_REV_GREEN}%-20.20s${COLOR_OFF}\n" "ok"
				#git status
				#echo
			} || {
				#echo -e "$TAG	${COLOR_REV_YELLOW}check message${COLOR_OFF}"
				printf "$TAG	${COLOR_REV_YELLOW}%-20.20s${COLOR_OFF}\n" "check messages"
				git status
				echo
			}
		} || {
			#echo -e "$TAG	${COLOR_REV_RED}something's wrong${COLOR_OFF}"
			printf "$TAG	${COLOR_REV_RED}%-20.20s${COLOR_OFF}\n" "something's wrong"
			git status
			echo
		}
		#echo
	)
done
