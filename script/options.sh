#!/bin/bash
set -uo pipefail

contacts_contains() {
    if jq '.[] | .name' contacts.json | grep -qw "$1"; then
        return 0 # true
    else
        return 1 # false
    fi
}

create_contact() {
    read -p "Inform the contact's name: " name
    contacts_contains $name

    if contacts_contains $name ; then
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

    if contacts_contains $name; then
        number=$(jq ".[] | select(.name==\"$name\") | .number" contacts.json)
        echo -e "Name: $name"
        echo -e "Number: $number\n"
    else 
        echo -e "This name does not exist in your list of contacts.\n"
    fi
}

update_contact() {
    read -p "Inform the contact's name: " name

    if contacts_contains $name; then
        read -p "Inform the new name of this contact: " new_name
        read -p "Inform the new number of this contact: " new_number

        # BUG: e se new_name já existir na lista?

        contact=$(jq ".[] | select(.name==\"$name\") | .name = \"$new_name\" | .number = \"$new_number\"" contacts.json)
        partial_list=$(jq "del(.[] | select(.name == \"$name\"))" contacts.json)
        updated_list=$(echo $partial_list | jq ". += [$contact]")
        echo $updated_list > contacts.json

        echo -e "\nThis contact has been successfully updated.\n"
    else
        echo -e "This name does not exist in your list of contacts.\n"
    fi
}

delete_contact() {
    read -p "Inform the contact's name: " name

    if contacts_contains $name; then
        updated_list=$(jq "del(.[] | select(.name == \"$name\"))" contacts.json)
        echo $updated_list > contacts.json

        echo -e "\nThis contact has been successfully removed.\n"
     else
        echo -e "This name does not exist in your list of contacts.\n"
    fi
}

exit_program() {
    echo -e "See you later!\n"
    exit 0
}

invalid_option() {
    echo -e "Invalid option, please try again.\n"
}
