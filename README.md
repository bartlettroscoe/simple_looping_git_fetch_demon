# Simple Looping Git Fetch Demon

This Git repo provides a demonstration of simple looping demon that does an
action when new commits are pulled from a branch in a remote Git repo.

To demonstrate this script, just clone a git repo and put it on the branch you
want like:

```
git clone <some-repo>.git
cd <some-repo>/
git checkout --track origin/<some-branch>
```

Then start the demon (with a 3m interval between loop iterations) like:

```
simple_looping_git_fetch_demon.sh 3m
```

This demon will then pull commits from the remote, and if new commits are
found, it will run an action.  (The default action is to just print the top
commit).

This simple script needs a little more to be robust.  One simple way to make
it more robust is to kill it and restart it every day like:

```
touch simple_looping_git_fetch_demon_last_pid.txt
lastJobPID=${cat simple_looping_git_fetch_demon_last_pid.txt}
if ps -p ${lastJobPID} > /dev/null ; then
  kill -s 9 ${lastJobPID}
fi
simple_looping_git_fetch_demon.sh 3m
echo "$!" >> simple_looping_git_fetch_demon_last_pid.txt
```

That will ensure that two or more demons are running on top of each other.
