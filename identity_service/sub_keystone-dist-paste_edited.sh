#!/bin/bash

sed -i.bak 's/admin_token_auth //g' /etc/keystone/keystone-paste.ini
