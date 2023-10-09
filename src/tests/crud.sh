#!/bin/bash
set -uo pipefail
source src/options.sh
source src/test/log.sh

export DB="src/test/contacts_test.json"
export PATH=$DB:$PATH

create_contact