#!/usr/bin/env bash
##Author: Angel Mariscurrena
##Repo: https://github.com/Mariscurrena/directory-fuzz
clear

# Colors Definition
GREEN="\033[30;42m"; GREENF="\033[0m"
BLUE="\033[34m"; BLUEF="\033[0m"
RED="\033[31;40m"; REDF="\033[0m"
PURPLE="\033[35m"; PURPLEF="\033[0m"

main(){
    while getopts ":u:w:m" option; do
        case $option in
            u) 
                target_url="$OPTARG"
                echo "Target URL: $target_url"
            ;;
            w)
                wordlist_path="$OPTARG"
                echo "Wordlist path: $wordlist_path"
            ;;
            m)
                echo -e "${PURPLE}For use this tool, you can use the following command structure:${PURPLEF}"
                echo ""
                echo -e "${PURPLE}---> Command: ./directory-fuzz.sh -u <TARGET_URL> -w <WORDLIST>${PURPLEF}"
                echo -e "${PURPLE}---> Example: ./directory-fuzz.sh -u https://www.example.com/product/ -w ./wordlist.txt${PURPLEF}"
                exit 0
            ;;
            \?)
                echo -e "${RED}Unknown option: -$OPTARG${REDF}" >&2
                exit 1
            ;;
        esac
    done
}

main "$@"