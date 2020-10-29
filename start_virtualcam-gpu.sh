#!/usr/bin/env bash

# remove the communication volume if it exists
docker volume inspect linux-fake-background-webcam_communication_volume > /dev/null 2>&1 \
  && docker volume rm linux-fake-background-webcam_communication_volume

# start the application
docker-compose -f docker-compose-gpu.yml up -d --build
