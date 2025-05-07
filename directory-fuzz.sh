#!/usr/bin/env bash
##Author: Angel Mariscurrena
##Repo: https://github.com/Mariscurrena/directory-fuzz
clear

# Colors Definition
GREEN="\033[30;42m"; GREENF="\033[0m"
BLUE="\033[34m"; BLUEF="\033[0m"
RED="\033[31;40m"; REDF="\033[0m"
PURPLE="\033[35m"; PURPLEF="\033[0m"

declare -a directories

url_validation(){
    ### Features:
    ############ -s Silent Mode
    ############ -o /dev/null Don't use response
    ############ -w "%{http_code}" Use just HTTP Code to see available resources
    ############ -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" This emulates another user-agent, in order to not be treated as a bot.
    ############ --head Just head request, not body needed
    curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" --head "$1"
}

file_reading(){
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        directories+=("$line")
    done < "$1"
}

main(){
    while getopts ":u:w:m" option; do
        case $option in
            u) 
                target_url="$OPTARG"
                if [ ${#directories[@]} -eq 0 ]; then
                    echo "Please specify a wordlist with -w first."
                    exit 1
                fi
                for dir in "${directories[@]}"; do
                    echo ">$dir<"
                done
            ;;
            w)
                wordlist_path="$OPTARG"
                directories=()
                file_reading "$wordlist_path"
            ;;
            m)
                echo -e "${PURPLE}For use this tool, you can use the following command structure:${PURPLEF}"
                echo ""
                echo -e "${PURPLE}---> Command: ./directory-fuzz.sh -w <WORDLIST> -u <TARGET_URL> ${PURPLEF}"
                echo -e "${PURPLE}---> Example: ./directory-fuzz.sh -w ./wordlist.txt -u https://www.example.com/product/${PURPLEF}"
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