#!/usr/bin/env bash

# reload the fakecam-gpu, this will load any changes from the .env-file
docker-compose -f docker-compose-gpu.yml stop fakecam-gpu
docker-compose -f docker-compose-gpu.yml up -d fakecam-gpu

