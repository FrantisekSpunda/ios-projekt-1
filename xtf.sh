#!/bin/bash

export POSIXLY_CORRECT=yes

user=""
command=""
logs=()
datetime_before="999999999999"
datetime_after=""
currency=""
XTF_PROFIT=20

function list() {
  echo ""
  echo "list"
  echo ""
  for log in "${logs[@]}"; do
    cat "$log"
  done | awk -F ';' -v user="$user" -v datetime_before="$datetime_before" -v datetime_after="$datetime_after" -v currency="$currency" -v command="$command" -v XTF_PROFIT="$XTF_PROFIT" '
    user == $1 && (currency == $3 || !currency) && datetime_before > $2 && datetime_after < $2 {
      if (command == "listCurrency") { currencies[$3] = 1 }
      else if (command == "list") { print }
      else if (command == "status" || command == "profit") {
        currencies[$3] = (currencies[$3] || 0) + $4
      }
    }

    END {
      for (currency in currencies) {
        if (command == "listCurrency")
          print currency
        else if (command == "status")
          print currency " : " currencies[currency]
        else if (command == "profit")
          print currency " : " currencies[currency] * (((XTF_PROFIT || 20) + 100) / 100)
      }
    }
  '

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

  list
}

main "$@"
