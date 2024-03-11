#!/bin/bash

export POSIXLY_CORRECT=yes

user=""
command=""
logs=()

function list() {
  echo ""
  for log in "${logs[@]}"; do
    awk -F ';' -v user="$user" '$1 == user' "$log"
  done
}

function listCurrency() {
  echo "x list currency"
}

function status() {
  echo "x status"
}

function profit() {
  echo "x profit"
}

function help() {
  clear
  echo "XTF is script for showing and filtering stocks informations from log file."
  echo "Usage: xtf [-h|--help] [FILTER] [COMMAND] USERNAME [LOG FILES]"
  echo ""
  echo "List of COMMANDs:"
  echo "  list"
  echo "  list-currency"
  echo "  status"
  echo "  profit"
  echo "List of FILTERs:"
  echo "  -a"
  echo "  -b"
  echo "  -c"
  echo "Others:"
  echo "  -h | --help"
  exit
}

function main() {

  # load all arguments
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
    # Filters
    -a)
      datetime_after="$2"
      shift
      ;;
    -b)
      datetime_before="$2"
      shift
      ;;
    -c)
      currency="$2" shift
      ;;
    -h | --help)
      help
      ;;
    # Commands
    list) command="list" ;;
    list-currency) command="listCurrency" ;;
    status) command="status" ;;
    profit) command="profit" ;;
    # Username and logs
    *)
      if [[ -z "$user" ]]; then
        user="$1"
      else
        logs+=("$1")
      fi
      ;;
    esac
    shift
  done

  # test print of arguments and theyer load
  echo "command: $command"
  echo "datetime_before: $datetime_before"
  echo "datetime_after: $datetime_after"
  echo "currency: $currency"
  echo "user: $user"
  for log in "${logs[@]}"; do
    echo "$log"
  done

  $command
}

main "$@"
