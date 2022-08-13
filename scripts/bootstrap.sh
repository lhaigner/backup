#!/usr/bin/env sh
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
. "$SCRIPTPATH/_base.sh"

getEncryptionPassphrase
getRepositories

for repo in $BORG_REPOS; do
  borg init --encryption repokey-blake2 "$repo"
done
