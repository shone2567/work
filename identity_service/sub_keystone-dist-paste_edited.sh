#!/bin/bash

sed -i.bak 's/admin_token_auth //g' /usr/share/keystone/keystone-dist-paste.ini
