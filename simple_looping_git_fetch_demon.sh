#!/bin/bash -e
#
# This simple bash script demonstrates how to run a looping demon that pulls
# new commits from a Git repo then the performns an action whenever new
# commits are pulled.
#
# This demon as currently written must be run from the base Git repo
# directory:
#
#   cd <gitRepo>/
#   simple_looping_git_fetch_demon.sh
#
# To make this more robust, start this demon at the same time every day and
# kill it if the last demon is still running.
#

# Get commandline args
SLEEP_DURATION=$1
if [[ "${SLEEP_DURATION}" == "" ]] ; then
  SLEEP_DURATION=30s
fi

# Produce a one-line but informative git log summary
function git_log_oneline {
  git log --pretty=format:'%Cgreen%h%Creset "%s" <%ae> [%ad] (%cr)' "$@"
}

# This is a placeholder for some action that is run whenever there are new
# commits
function do_something {
  topCommit=$(git_log_oneline --no-color -1)
  echo "Running action with top commit: ${topCommit}"
}

# Start the looping demon

firstIteration=true
while [[ 0 ]] ; do

  echo
  echo "***"
  echo "*** Look for new commits"
  echo "***"
  echo
  date
  echo
    
  # Update the local git repo and etermine if there are new commits
  git pull
  newCommits=$(git_log_oneline --no-color HEAD --not ORIG_HEAD)
  echo
  echo "New commits:"
  echo "${newCommits}"

  if [[ "${newCommits}" != "" ]] || [[ "${firstIteration}" == "true" ]] ; then
    do_something
  fi
    
  # Pause for a bit so we don't hammer the Git server or this machine
  sleep ${SLEEP_DURATION}

  firstIteration=false

done

# NOTE: Above, there is a little more that needs to be added to make this
# robust:
#
# 1. If the action `do_something` is currently running, then it needs to be
#    killed before starting the loop again.
#
# 2. There should be a termination time so the loop terminates and does not
#    run forever.
