#!/usr/bin/env bash

# stop the application and delete the communication-volume
docker-compose -f docker-compose-gpu.yml down --remove-orphans \
  && docker volume rm linux-fake-background-webcam_communication_volume
