#!/usr/bin/env sh
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

if [ -z "$KEEPASS_PATH" ]; then
  printf "KeePassXC file path: "
  read -r KEEPASS_PATH
  export KEEPASS_PATH
fi

if [ -z "$KEEPASS_PASSPHRASE" ]; then
  stty -echo
  printf "KeePassXC passphrase: "
  read -r KEEPASS_PASSPHRASE
  export KEEPASS_PASSPHRASE
  stty echo
  printf "\n"
fi

. "$SCRIPTPATH/recovery.sh"

for repoPath in ./*; do
  if ! echo "$KEEPASS_PASSPHRASE" | keepassxc-cli db-info "$repoPath/$KEEPASS_PATH" > "$repoPath/report.txt" 2>&1; then
    repo=$(cat "$repoPath/.repo.txt")
    createIncidentAndExit "Backup test failed for $repo)"
  fi
done

createReport TestBackup