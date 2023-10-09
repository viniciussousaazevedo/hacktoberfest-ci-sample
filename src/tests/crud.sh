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
        fi
    else
        if [ "$output" != "$error_message" ] ; then
            log info "READ: $1"
        else
            log error "COULD NOT READ: $1"
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

creation_test
read_test