#!/usr/bin/env bash

output::answer "Installing Deno deploy"
deno install --allow-read --allow-write --allow-env --allow-net --allow-run --no-check -f https://deno.land/x/deploy/deployctl.ts
