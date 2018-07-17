#!/bin/bash
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
RED_COLOR="\033[31m"
GREEN_COLOR="\033[32m"
YELLOW_COLOR="\033[33m"
HIGHLIGHT="\033[1m"
END_COLOR="\033[0m"

function error
{
    echo -ne "$RED_COLOR"
    echo "$@"
    echo -ne "$END_COLOR"
}

function warn
{
    echo -ne "$YELLOW_COLOR"
    echo "$@"
    echo -ne "$END_COLOR"
}

function ok
{
    echo -ne "$GREEN_COLOR"
    echo "$@"
    echo -ne "$END_COLOR"
}

function check_exit
{
    [ $1 -ne 0 ] && error "$2" && exit 1
}

function usage
{
	echo -e "Usage:\n\t$0 "
}

function process_argv
{
    while [ -n "$1" ]; do
        case "$1" in
            -v|--value)
                if [ -z "$2" -o "${2#-*}" != "$2" ]; then
                    usage
                else
                    value=$2
                fi
                shift 2
                ;;
            *)
                usage
                ;;
        esac
    done

    [ -z "$value" ] && {
        error "must be set value"
        exit 1
    }
}

process_argv "$@"
