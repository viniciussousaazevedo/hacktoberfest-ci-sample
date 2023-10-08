#!/bin/bash
set -uo pipefail

create_contact() {
    read -p "Inform the contact's name: " name
    read -p "Inform the contact's number: " number
    echo "$name, $number" >> contacts.csv

    echo -e "\nThe contact was successfully saved.\n"
}

read_contact() {
    echo "TODO"
}

update_contact() {
    echo "TODO"
}

delete_contact() {
    echo "TODO"
}

exit_program() {
    echo -e "See you later!\n"
    exit 0
}

invalid_option() {
    echo -e "Invalid option, please try again.\n"
}
