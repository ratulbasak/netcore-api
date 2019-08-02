#!/bin/bash

DOMAIN=$1
BRANCH_NAME=$2

PROJECT_PATH="/root/deployments/$BRANCH_NAME/$DOMAIN"
SERVICE_PATH="/root/deployments/systemd/netcore-api.service"
# SERVICE_PATH="netcore-api.service"
SYSTEMD_FILE="/etc/systemd/system/netcore-$BRANCH_NAME-$DOMAIN.service"

UpdateSystemD() {
  echo "copying systemd file..."
  cp $SERVICE_PATH $SYSTEMD_FILE
  sed -i "s/WorkingDirectory.*/WorkingDirectory=\/root\/deployments\/$BRANCH_NAME\/$DOMAIN/" $SYSTEMD_FILE
}

CheckFile() {
  if [[ -f "$SYSTEMD_FILE" ]]; then
    echo "$SYSTEMD_FILE exist"
  else
    echo "$SYSTEMD_FILE not exist"
    UpdateSystemD
  fi
}

Main() {
  CheckFile
  systemctl daemon-reload
  systemctl restart netcore-$BRANCH_NAME-$DOMAIN.service
}

Main
