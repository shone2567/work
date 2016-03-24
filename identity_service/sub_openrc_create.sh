#!/bin/bash

cat<<EOF >admin-openrc.sh

export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=Super123
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

EOF

cat<<EOF >demo-openrc.sh

export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=demo
export OS_TENANT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=Super123
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

EOF

exit 0


