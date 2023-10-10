#!/bin/bash
set -uo pipefail
export DB="src/contacts.json"
export PATH=$DB:$PATH

create_database() {
    if [ -s $DB ] || [ ! -f $DB ] ; then
        echo "[]" > $DB
    fi
}

contacts_contains() {
    if jq '.[] | .name' $DB | grep -qw "$1"; then
        return 0 # true
    else
        return 1 # false
    fi
}

create_contact() {
    if contacts_contains $1 ; then
        echo -e "\nThis name already exists in your list of contacts.\n"
        return
    fi

    updated_list=$(cat $DB | jq ". += [{
        \"name\": \"$1\",
        \"number\": \"$2\"
    }]")

    echo $updated_list > $DB

    echo -e "\nThe contact was successfully saved.\n"
}

read_contact() {
    if contacts_contains $1; then
        number=$(jq ".[] | select(.name==\"$1\") | .number" $DB)
        echo -e "Name: $1"
        echo -e "Number: $number\n"
    else 
        echo -e "This name does not exist in your list of contacts.\n"
    fi
}

update_contact() {

    if contacts_contains $1; then

        

        contact=$(jq ".[] | select(.name==\"$1\") | .name = \"$2\" | .number = \"$3\"" $DB)
        partial_list=$(jq "del(.[] | select(.name == \"$1\"))" $DB)
        updated_list=$(echo $partial_list | jq ". += [$contact]")
        echo $updated_list > $DB

        echo -e "\nThis contact has been successfully updated.\n"
    else
        echo -e "This name does not exist in your list of contacts.\n"
    fi
}

delete_contact() {
    if contacts_contains $1; then
        updated_list=$(jq "del(.[] | select(.name == \"$1\"))" $DB)
        echo $updated_list > $DB

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
