#!/bin/bash

# abort on all failures
set -e

# enable keychain
if [ -f $HOME/.keychain/${HOSTNAME}-sh ] ; then
  source $HOME/.keychain/${HOSTNAME}-sh
fi

# checkout a fresh copy
svn co svn+ssh://svn.corp.linkedin.com/netrepo/network/trunk/content/static/scss/lib/ /tmp/sassdoc/lib/
# process it
$HOME/workspace/sassdoc/sassdoc.rb /tmp/sassdoc/lib/davinci/ > /tmp/sassdoc/sassdoc.json
# push new docs
scp /tmp/sassdoc/sassdoc.json adam@developer.linkedinlabs.com:/shared/developer/scssdoc/
