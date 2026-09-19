#!/usr/bin/env bash

## Clears the kitty graphics placed by preview.sh. Called by lf when the
## previously selected file's preview exited non-zero (volatile previews).

exec kitten icat --clear --stdin no --transfer-mode memory </dev/null >/dev/tty
