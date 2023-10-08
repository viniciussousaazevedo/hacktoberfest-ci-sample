#!/bin/bash
set -uo pipefail
source options.sh

print_menu() {
    echo "=-=-= What do you want to do? =-=-="
    echo "(C)reate contact"
    echo "(R)ead contact"
    echo "(U)pdate contact"
    echo "(D)elete contact"

    echo -e "\n(E)xit program\n"
}

analyse_input() {
    parameter="$1"
    input="${parameter^^}"
    case $input in
        C)
            create_contact ;;
        R)
            read_contact ;;
        U)
            update_contact ;;
        D)
            delete_contact ;;
        E)
            exit_program ;;
        *)
            invalid_option ;;
    esac
}

main() {
    while true; do
        print_menu
        read -p "Enter your choice: " input
        analyse_input $input
    done
}

main
