#!/bin/bash

export PYTHONUNBUFFERED=1

#echo "**** Setting the timezone based on the TIME_ZONE environment variable. If not set, it defaults to Etc/UTC. ****" && \
export TZ=${TIME_ZONE:-"Etc/UTC"} && \
echo "**** Timezone set to $TZ ****" && \
echo "$TZ" | sudo tee /etc/timezone > /dev/null && \
sudo ln -sf "/usr/share/zoneinfo/$TZ" /etc/localtime && \
sudo dpkg-reconfigure -f noninteractive tzdata

mkdir -p /workspace/logs /workspace/models
