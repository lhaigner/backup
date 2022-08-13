#!/usr/bin/env sh
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
. "$SCRIPTPATH/_base.sh"

getEncryptionPassphrase
getRepositories

archive=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

for BORG_REPO in $BORG_REPOS; do
  export BORG_REPO
  if ! borg create --verbose --list --stats --show-rc --compression lz4 ::"{hostname}-$archive" "$@"; then
    createIncidentAndExit "Backup creation failed for $BORG_REPO"
  fi
  if ! borg prune --list --prefix '{hostname}-' --show-rc --keep-daily 7 --keep-weekly 4 --keep-monthly 6; then
    createIncidentAndExit "Backup prune failed for $BORG_REPO"
  fi
done

createReport CreateBackup