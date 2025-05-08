#!/usr/bin/env bash
##Author: Angel Mariscurrena
##Repo: https://github.com/Mariscurrena/directory-fuzz
clear

# Colors Definition
GREEN="\033[30;42m"; GREENF="\033[0m"
BLUE="\033[34m"; BLUEF="\033[0m"
RED="\033[31;40m"; REDF="\033[0m"
PURPLE="\033[35m"; PURPLEF="\033[0m"
YELLOW="\033[33m"; YELLOWF="\033[0m"

declare -a directories

url_validation(){
    ### Features:
    ############ -s Silent Mode
    ############ -o /dev/null Don't use response
    ############ -w "%{http_code}" Use just HTTP Code to see available resources
    ############ -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" This emulates another user-agent, in order to not be treated as a bot.
    ############ --head Just head request, not body needed
    ############ ----> echo "curl -s -o /dev/null -w \"%{http_code}\" -A \"Mozilla/5.0 (Windows NT 10.0; Win64; x64)\" --head \"$url\""
    target_url=$1
    for dir in "${directories[@]}"; do
        status_code=$(curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" --head "$target_url$dir")
        if [[ "$status_code" == "000" ]]; then
            echo -e "${RED}ERROR${REDF} ${YELLOW}You are trying to execute this tool in an incompatible environment. It is probable that you do not have a compatible curl version.${YELLOWF}"
            echo ""
            echo -e "${PURPLE}Current curl version: ${PURPLEF}"
            curl --version
            sleep 1
            exit 1
        elif [[ "$status_code" =~ ^(4|5) ]]; then
            echo -e "${RED}Code: $status_code${REDF} ${BLUE}--- ERROR ---${BLUEF} $target_url$dir"
        else
            echo -e "${GREEN}Code: $status_code${GREENF} ${BLUE}--- SUCCESSFUL ---${BLUEF} $target_url$dir"
        fi
        sleep 1 ### Delay between requests in order to not alert the server, WAF or any other security measure
    done
}

wordlist_validation(){
    if [ ${#directories[@]} -eq 0 ]; then
        echo -e "${PURPLE}Please follow the command structure:${PURPLEF}"
        echo -e "${PURPLE}----> ./directory-fuzz.sh -w <WORDLIST> -u <TARGET_URL>${PURPLEF}"
        exit 1
    fi
}

tool_manual(){
    echo -e "${PURPLE}For use this tool, you can use the following command structure:${PURPLEF}"
    echo ""
    echo -e "${PURPLE}---> Command: ./directory-fuzz.sh -w <WORDLIST> -u <TARGET_URL> ${PURPLEF}"
    echo -e "${PURPLE}---> Example: ./directory-fuzz.sh -w ./wordlist.txt -u https://www.example.com/product/${PURPLEF}"
    sleep 2
    exit 0
}

file_reading(){
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        directories+=("$line")
    done < "$1"
}

initial_message(){
    echo -e "${BLUE}##############################################"
    echo -e "${BLUE}#                                            #"
    echo -e "${BLUE}#           ${BLUE}WEB DIRECTORY FUZZING            #"
    echo -e "${BLUE}#                                            #"
    echo -e "${BLUE}##############################################"
    echo ""
    echo -e "${YELLOW}Author:${YELLOWF} Angel Mariscurrena"
    echo ""
    echo -e "${YELLOW}Description: ${YELLOWF}This tool is designed for web directory fuzzing. Helps security engineers and penetration testers discover hidden directories, files, and resources within a website. By sending a series of requests to a target URL with various combinations of paths from a word list, this tool helps identify valid endpoints that may not be publicly visible or hidden behind access controls."
    echo ""
    sleep 2
    echo -e "${BLUE}TARGET URL${BLUEF}: $1"
    echo ""
    echo -e "${BLUE}---> RESULTS: ${BLUEF}"
    echo ""
}

main(){
    while getopts ":w:u:m" option; do
        case $option in
            w)
                wordlist_path="$OPTARG"
                directories=()
                file_reading "$wordlist_path"
            ;;
            u) 
                target_url="$OPTARG"
                initial_message $target_url
                wordlist_validation
                url_validation $target_url
                echo ""
            ;;
            m)
                tool_manual
            ;;
            \?)
                echo -e "${RED}Unknown option: -$OPTARG${REDF}" >&2
                exit 1
            ;;
        esac
    done
}

main "$@"