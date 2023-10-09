#!/bin/bash
set -uo pipefail
source src/options.sh

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
            create_contact_menu ;;
        R)
            read_contact_menu ;;
        U)
            update_contact_menu ;;
        D)
            delete_contact_menu ;;
        E)
            exit_program ;;
        *)
            invalid_option ;;
    esac
}

create_contact_menu() {
    read -p "Inform the contact's name: " name
    read -p "Inform the contact's number: " number

    create_contact $name $number
}

read_contact_menu() {
    read -p "Inform the contact's name: " name
    read_contact $name
}

update_contact_menu() {
    read -p "Inform the contact's name: " name
    read -p "Inform the new name of this contact: " new_name
    read -p "Inform the new number of this contact: " new_number
    update_contact $name $new_name $new_number
}

delete_contact_menu() {
    read -p "Inform the contact's name: " name
    delete_contact $name
}


main() {
    while true; do
        print_menu
        read -p "Enter your choice: " input
        analyse_input $input
    done
}

main
