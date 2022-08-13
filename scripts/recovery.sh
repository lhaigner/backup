#!/usr/bin/env sh
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
. "$SCRIPTPATH/_base.sh"

getEncryptionPassphrase
getRepositories

BASEPATH=$(pwd)

for BORG_REPO in $BORG_REPOS; do
  export BORG_REPO
  hash=$(printf %s "$BORG_REPO" | md5sum | awk '{ print $1 }')
  mkdir "$BASEPATH/$hash"
  cd "$BASEPATH/$hash" || createIncidentAndExit "Backup extraction failed for $BORG_REPO"
  repo=$BORG_REPO
  case $BORG_REPO in
    *@*) BORG_REPO="$repo" ;;
    /*)  BORG_REPO="$repo" ;;
    *)   BORG_REPO="../$repo" ;;
    esac
  echo borg extract "$BORG_REPO::$1"
  if ! borg extract "$BORG_REPO::$1"; then createIncidentAndExit "Backup extraction failed for $repo"; fi
  echo "$repo" > .repo.txt
  cd "$BASEPATH" || createIncidentAndExit "Backup extraction failed for $repo"
done