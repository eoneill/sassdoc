#!/bin/bash

# abort on all failures
set -e

# enable bash profile
if [ -f $HOME/.bash_profile ] ; then
  source $HOME/.bash_profile
  echo "profile enabled" >> $HOME/Desktop/cron.log
fi


# checkout a fresh copy
svn co svn+ssh://svn.corp.linkedin.com/netrepo/network/trunk/content/static/scss/lib/ /tmp/sassdoc/lib/ 2> $HOME/Desktop/cron.log
# process it
$HOME/workspace/sassdoc/sassdoc.rb /tmp/sassdoc/lib/davinci/ > /tmp/sassdoc/sassdoc.json
# push new docs
scp /tmp/sassdoc/sassdoc.json adam@developer.linkedinlabs.com:/shared/developer/scssdoc/ 2> $HOME/Desktop/cron.log
