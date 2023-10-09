#!/bin/bash
set -uo pipefail
source src/options.sh
source src/tests/log.sh

export DB="src/tests/contacts_test.json"
export PATH=$DB:$PATH

# TODO trocar grep por jq nas funções de teste unitário

create_single_contat() {

    if [ $(cat $DB | grep -c $1) -eq "0" ] ; then
        create_contact $1 $2 > /dev/null
        if [ $(cat $DB | grep -c $1) -eq "1" ] ; then
            log info "CREATED: $1, $2"
        else
            log error "WAS NOT CREATED: $1, $2"
            exit 1
        fi
    else
        create_contact $1 $2 > /dev/null
        if [ $(cat $DB | grep -c $1) -eq "1" ] ; then
            log info "ALREADY EXISTS: $1, $2"
        else
            log error "DELETED OR DUPLICATED: $1, $2"
            exit 1
        fi
    fi
}

read_single_contat() {
    output=$(read_contact $1)
    error_message="This name does not exist in your list of contacts."
    if [ $(cat $DB | grep -c $1) -eq "0" ] ; then
        if [ "$output" == "$error_message" ] ; then
            log info "DOES NOT EXIST: $1"
        else
            log error "READ WRONG CONTENT: $1"
            exit 1
        fi
    else
        if [ "$output" != "$error_message" ] ; then
            log info "READ: $1"
        else
            log error "COULD NOT READ: $1"
            exit 1
        fi
    fi
}

update_single_contact() {
    if [ $(cat $DB | grep -c $1) -eq "0" ] ; then
        update_contact $1 $2 $3 > /dev/null
        if [ $(cat $DB | grep -c $1) -eq "0" ] ; then
            log info "CONTACT DOES NOT EXIST: $1 -> $2"
        else
            log error "INVALID CONTACT UPDATED: $1 -> $2"
            exit 1
        fi
    else
        update_contact $1 $2 $3 > /dev/null
        if [ $(cat $DB | grep -c $2) -eq "1" ] ; then
            # TODO é preciso checar o número novo também
            log info "UPDATED CONTACT: $1 -> $2"
        else
            log error "CONTACT REMOVED OR DUPLICATED: $1 -> $2"
            exit 1
        fi
    fi
}

delete_single_contact() {
    if [ $(cat $DB | grep -c $1) -eq "0" ] ; then
        delete_contact $1 > /dev/null
        if [ $(cat $DB | grep -c $1) -eq "0" ] ; then
            log info "CONTACT DOES NOT EXIST: $1"
        else
            log error "CONTACT HAS BEEN CREATED: $1"
            exit 1
        fi
    else
        delete_contact $1 > /dev/null
        if [ $(cat $DB | grep -c $1) -eq "0" ] ; then
            log info "CONTACT HAS BEEN REMOVED: $1"
        else
            log error "CONTACT HAS NOT BEEN REMOVED: $1"
            exit 1
        fi
    fi
}

creation_test() {
    echo "[]" > $DB
    log info "===== INITIALIZING CREATION TEST ====="
    create_single_contat "vinicius" "8399958"
    create_single_contat "anabelle" "8399958"
    create_single_contat "geraldo" "4455"
    create_single_contat "vinicius" "1123"
    create_single_contat "neto" "1123"
    create_single_contat "neto" "1123"
}

read_test() {
    log info "===== INITIALIZING READ TEST ====="
    read_single_contat "vinicius"
    read_single_contat "neto"
    read_single_contat "amanda"
    read_single_contat "victor"
    read_single_contat "vinicius"
    read_single_contat "geraldo"
}

update_test() {
    log info "===== INITIALIZING UPDATE TEST ====="
    update_single_contact "vinicius" "alberto" "8333"
    update_single_contact "alberto" "vinicius" "9999"
    update_single_contact "neto" "neto" "5555"
    update_single_contact "rejane" "melina" "123456"
    update_single_contact "melina" "felicia" "1111"
    update_single_contact "vinicius" "neto" "0000" # FIXME
}

deletion_test() {
    log info "===== INITIALIZING DELETION TEST ====="
    delete_single_contact "melina"
    delete_single_contact "anabelle"
    delete_single_contact "neto"
    delete_single_contact "neto"
    delete_single_contact "ed"
    delete_single_contact "neto"
    delete_single_contact "vinicius"
}

creation_test
read_test
update_test
deletion_test