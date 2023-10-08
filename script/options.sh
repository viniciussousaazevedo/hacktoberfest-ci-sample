#!/bin/bash
set -uo pipefail

create_contact() {
    read -p "Inform the contact's name: " name

    if jq '.[] | .name' contacts.json | grep $name > /dev/null; then
        echo -e "\nThis name already exists in your list of contacts.\n"
        return
    fi

    read -p "Inform the contact's number: " number

    updated_list=$(cat contacts.json | jq ". += [{
        \"name\": \"${name}\",
        \"number\": \"${number}\"
    }]")

    echo $updated_list > contacts.json

    echo -e "\nThe contact was successfully saved.\n"
}

read_contact() {
    read -p "Inform the contact's name: " name

    if jq '.[] | .name' contacts.json | grep $name > /dev/null; then
        number=$(jq ".[] | select(.name==\"$name\") | .number" contacts.json)
        echo -e "Name: $name"
        echo -e "Number: $number\n"
    else 
        echo -e "This name does not exist in your list of contacts.\n"
    fi
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
