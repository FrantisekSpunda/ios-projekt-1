#!/bin/bash


export POSIXLY_CORRECT=yes


function help() {
  echo "XTF is script for showing and filtering stocks informations from log file."
  echo "Usage: xtf [-h|--help] [FILTER] [COMMAND] USERNAME [LOG FILES]"
  echo ""
  echo "List of COMMANDs:"
  echo ""
  exit
}

function main() {

  while getopts ":c:a:b:h" opt; do
    case opt in
      h|help) help ;;
      c)
    esac
}


main "$@"