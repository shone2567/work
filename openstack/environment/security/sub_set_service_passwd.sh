#!/bin/bash
#Database password (no variable used)=$(openssl rand -hex 10)	#Root password for the database
	
sub_set_service_passwd(){
	
	ADMIN_PASS=$(openssl rand -hex 10)	##Password of user admin
	CEILOMETER_DBPASS=$(openssl rand -hex 10)	##Database password for the Telemetry service
	CEILOMETER_PASS=$(openssl rand -hex 10)	#Password of Telemetry service user ceilometer
	CINDER_DBPASS=$(openssl rand -hex 10)	#Database password for the Block Storage service
	CINDER_PASS=$(openssl rand -hex 10)	#Password of Block Storage service user cinder
	DASH_DBPASS=$(openssl rand -hex 10)	#Database password for the dashboard
	DEMO_PASS=$(openssl rand -hex 10)	#Password of user demo
	GLANCE_DBPASS=$(openssl rand -hex 10)	#Database password for Image service
	GLANCE_PASS=$(openssl rand -hex 10)	#Password of Image service user glance
	HEAT_DBPASS=$(openssl rand -hex 10)	#Database password for the Orchestration service
	HEAT_DOMAIN_PASS=$(openssl rand -hex 10)	#Password of Orchestration domain
	HEAT_PASS=$(openssl rand -hex 10)	#Password of Orchestration service user heat
	KEYSTONE_DBPASS=$(openssl rand -hex 10)	#Database password of Identity service
	NEUTRON_DBPASS=$(openssl rand -hex 10)	#Database password for the Networking service
	NEUTRON_PASS=$(openssl rand -hex 10)	#Password of Networking service user neutron
	NOVA_DBPASS=$(openssl rand -hex 10)	#Database password for Compute service
	NOVA_PASS=$(openssl rand -hex 10)	#Password of Compute service user nova
	RABBIT_PASS=$(openssl rand -hex 10)	#Password of user guest of RabbitMQ
	SWIFT_PASS=$(openssl rand -hex 10)	#Password of Object Storage service user swift

}
	
