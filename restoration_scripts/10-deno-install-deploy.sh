#!/usr/bin/env bash

output::answer "Installing deno"
"${SLOTH_PATH:-$DOTLY_PATH}/bin/dot" package add deno

output::answer "Installing Deno deploy"
deno install --allow-read --allow-write --allow-env --allow-net --allow-run --no-check -f https://deno.land/x/deploy/deployctl.ts
