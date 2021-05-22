#!/usr/bin/env bash

service='switch.turn_on'
json='{"device_id":"c86044ee08b611eb8110d581c1d28654"}'

"$DOTLY_PATH/bin/dot" ha service "$service" "$json" >/dev/null || exit 1

service='light.turn_on'
json='{}'