#!/usr/bin/env sh
export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes

createReport() {
  if [ -n "$ID_API_TOKEN" ]; then
    curl -X POST "https://api.eu.opsgenie.com/v2/heartbeats/$1/ping" --header "Authorization: GenieKey $ID_API_TOKEN"
  else
    echo "createReport $1"
  fi
}

createIncidentAndExit() {
  if [ -n "$ID_API_TOKEN" ]; then
    curl -X POST https://api.eu.opsgenie.com/v2/alerts \
    -H "Content-Type: application/json" \
    -H "Authorization: GenieKey $ID_API_TOKEN" \
    -d \
'{
    "message": "'"$1"'",
    "entity": "Backup",
    "priority":"P3"
}'
  else
    echo "createIncidentAndExit $1"
  fi
  exit 1
}

getEncryptionPassphrase() {
  if [ -z "$BORG_PASSPHRASE" ]; then
    stty -echo
    printf "Encryption passphrase: "
    read -r BORG_PASSPHRASE
    export BORG_PASSPHRASE
    stty echo
    printf "\n"
  fi
}

getRepositories() {
  if [ -z "$BORG_REPOS" ]; then
    set -- "$HOME/.backup"

    for repo in "BorgBase"; do
      printf "%s repository: " "$repo"
      read -r BORG_REPO
      set -- "$@" "$BORG_REPO"
    done

    BORG_REPOS=$*
    export BORG_REPOS
  fi
}
