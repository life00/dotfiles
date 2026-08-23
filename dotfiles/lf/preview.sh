#!/usr/bin/env bash

## This script is an adapter to use a joshuto-style preview script with lf.
## It expects the following positional arguments from lf/ranger:
## $1: FILE_PATH
## $2: PREVIEW_WIDTH
## $3: PREVIEW_HEIGHT

IFS=$'\n'

# Security measures:
set -o noclobber -o noglob -o nounset -o pipefail

# Enable exiftool large file support
shopt -s expand_aliases
alias exiftool='exiftool -api largefilesupport=1'

# 1. Adapt to lf's positional arguments
FILE_PATH="${1}"
# Check if $2 is empty. If it is, assume we're in full screen and use tput cols for width.
# If $2 is set (i.e., lf called it for the side pane), use $2.
PREVIEW_WIDTH="${2:-$(tput cols)}"
PREVIEW_HEIGHT="${3:-}" # We can still default height as it's not strictly needed for bat width.

# Guard clause to ensure path is not empty
if [ -z "$FILE_PATH" ]; then
  exit 1
fi

handle_extension() {
  case "${FILE_EXTENSION_LOWER}" in
  ## Archive
  a | ace | alz | arc | arj | bz | bz2 | cab | cpio | deb | gz | jar | lha | lz | lzh | lzma | lzo | \
    rpm | rz | t7z | tar | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z | zip | rar | 7z)
    lsar "${FILE_PATH}" | head -n 15 && printf "\n" &&
      exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;
    ## PDF
  pdf)
    ## Preview as text conversion
    exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;

    ## BitTorrent
  torrent)
    exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;

    ## OpenDocument
  odt | sxw)
    ## Preview as markdown conversion
    pandoc -s -t markdown -- "${FILE_PATH}" | bat -l markdown \
      --color=always --paging=never \
      --style=plain \
      --terminal-width="${PREVIEW_WIDTH}" | head -n 15 && printf "\n" &&
      printf "\n...\n\n" &&
      exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;
  ods | odp)
    ## Preview as text conversion (unsupported by pandoc for markdown)
    exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;

    ## XLSX
  xlsx)
    ## Preview as csv conversion
    ## Uses: https://github.com/dilshod/xlsx2csv
    exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;

    ## HTML
  htm | html | xhtml)
    ## Preview as text conversion
    pandoc -s -t markdown -- "${FILE_PATH}" | bat -l markdown \
      --color=always --paging=never \
      --style=plain \
      --terminal-width="${PREVIEW_WIDTH}" | head -n 15 && printf "\n" &&
      exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    ;;

    ## JSON
  json | ipynb)
    jq --color-output . "${FILE_PATH}" | head -n 15 && printf "\n" &&
      exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0

    ;;

    ## Direct Stream Digital/Transfer (DSDIFF) and wavpack aren't detected
    ## by file(1).
  dff | dsf | wv | wvc)
    exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    ;; # Continue with next handler on failure
  esac
}

handle_mime() {
  local mimetype="${1}"

  case "${mimetype}" in
  ## RTF and DOC
  text/rtf | *msword)
    ## Preview as text conversion
    ## note: catdoc does not always work for .doc files
    ## catdoc: http://www.wagner.pp.ru/~vitus/software/catdoc/
    pandoc -s -t markdown -- "${FILE_PATH}" | head -n 15 && printf "\n" &&
      exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;

    ## DOCX, ePub, FB2 (using markdown)
    ## You might want to remove "|epub" and/or "|fb2" below if you have
    ## uncommented other methods to preview those formats
  *wordprocessingml.document | */epub+zip | */x-fictionbook+xml)
    ## Preview as markdown conversion
    pandoc -s -t markdown -- "${FILE_PATH}" | bat -l markdown \
      --color=always --paging=never \
      --style=plain \
      --terminal-width="${PREVIEW_WIDTH}" | head -n 15 && printf "\n" &&
      exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;

    ## E-mails
  message/rfc822)
    ## Parsing performed by mu: https://github.com/djcb/mu
    exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;

    ## XLS
  *ms-excel)
    ## Preview as csv conversion
    ## xls2csv comes with catdoc:
    ##   http://www.wagner.pp.ru/~vitus/software/catdoc/
    exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;

    ## Text
  text/* | */xml)
    bat --color=always --paging=never \
      --style=plain \
      --terminal-width="${PREVIEW_WIDTH}" \
      "${FILE_PATH}" | head -n 15 && printf "\n" &&
      exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0

    exit 1
    ;;

    ## Image
  image/*)
    ## Preview as text conversion
    printf "\n" && exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;

    ## Video and audio
  video/* | audio/*)
    exiftool "${FILE_PATH}" | bat -l yaml --color=always --paging=never --style=plain && exit 0
    exit 1
    ;;
  esac
}

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"
handle_extension
MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
handle_mime "${MIMETYPE}"

(exiftool "${FILE_PATH}" || printf "\n" && file "${FILE_PATH}") | bat -l yaml --color=always --paging=never --style=plain && exit 0

exit 1
