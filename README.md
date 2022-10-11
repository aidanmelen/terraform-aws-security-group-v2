[![Pre-Commit](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml)
[![Terratest](https://img.shields.io/badge/Terratest-enabled-blueviolet)](https://github.com/aidanmelen/terraform-aws-security-group-v2#tests)
[![Tfsec](https://img.shields.io/badge/tfsec-enabled-blue)](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml)

# terraform-aws-security-v2

Terraform module which creates [EC2 security group within VPC](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html) on AWS.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Features

This module aims to implement **ALL** combinations of `aws_security_group` and `aws_security_group_rule` arguments supported by AWS and latest stable version of Terraform.

What's more, this module was designed after the [terraform-aws-modules/terraform-aws-security-group](https://github.com/terraform-aws-modules/terraform-aws-security-group#features) module and aims to have feature parody. Please see the [Acknowledgments](https://github.com/aidanmelen/terraform-aws-security-group-v2/blob/main/README.md#acknowledgments) section for more information.

### Rule Aliases

**Manage Rules**:

<details><summary>Click to show</summary>

```hcl
# Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
# All = 0, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58
locals {
  managed_rule_aliases = {
    # ActiveMQ
    activemq-5671-tcp  = { "to_port" = 5671, "from_port" = 5671, "protocol" = "tcp", description = "ActiveMQ AMQP" }
    activemq-8883-tcp  = { "to_port" = 8883, "from_port" = 8883, "protocol" = "tcp", description = "ActiveMQ MQTT" }
    activemq-61614-tcp = { "to_port" = 61614, "from_port" = 61614, "protocol" = "tcp", description = "ActiveMQ STOMP" }
    activemq-61617-tcp = { "to_port" = 61617, "from_port" = 61617, "protocol" = "tcp", description = "ActiveMQ OpenWire" }
    activemq-61619-tcp = { "to_port" = 61619, "from_port" = 61619, "protocol" = "tcp", description = "ActiveMQ WebSocket" }
    # Alert Manager
    alertmanager-9093-tcp = { "to_port" = 9093, "from_port" = 9093, "protocol" = "tcp", description = "Alert Manager" }
    alertmanager-9094-tcp = { "to_port" = 9094, "from_port" = 9094, "protocol" = "tcp", description = "Alert Manager Cluster" }
    # Carbon relay
    carbon-line-in-tcp = { "to_port" = 2003, "from_port" = 2003, "protocol" = "tcp", description = "Carbon line-in" }
    carbon-line-in-udp = { "to_port" = 2003, "from_port" = 2003, "protocol" = "udp", description = "Carbon line-in" }
    carbon-pickle-tcp  = { "to_port" = 2013, "from_port" = 2013, "protocol" = "tcp", description = "Carbon pickle" }
    carbon-pickle-udp  = { "to_port" = 2013, "from_port" = 2013, "protocol" = "udp", description = "Carbon pickle" }
    carbon-admin-tcp   = { "to_port" = 2004, "from_port" = 2004, "protocol" = "tcp", description = "Carbon admin" }
    carbon-gui-udp     = { "to_port" = 8081, "from_port" = 8081, "protocol" = "tcp", description = "Carbon GUI" }
    # Cassandra
    cassandra-clients-tcp        = { "to_port" = 9042, "from_port" = 9042, "protocol" = "tcp", description = "Cassandra clients" }
    cassandra-thrift-clients-tcp = { "to_port" = 9160, "from_port" = 9160, "protocol" = "tcp", description = "Cassandra Thrift clients" }
    cassandra-jmx-tcp            = { "to_port" = 7199, "from_port" = 7199, "protocol" = "tcp", description = "JMX" }
    # Confluent
    confluent-schema-registry = { "to_port" = 8081, "from_port" = 8081, "protocol" = "tcp", description = "Confluent Schema Registry" }
    confluent-control-center  = { "to_port" = 9021, "from_port" = 9021, "protocol" = "tcp", description = "Confluent Control Center" }
    confluent-ksqldb          = { "to_port" = 8088, "from_port" = 8088, "protocol" = "tcp", description = "Confluent KsqlDB" }
    # Consul
    consul-tcp             = { "to_port" = 8300, "from_port" = 8300, "protocol" = "tcp", description = "Consul server" }
    consul-grpc-tcp        = { "to_port" = 8502, "from_port" = 8502, "protocol" = "tcp", description = "Consul gRPC" }
    consul-webui-http-tcp  = { "to_port" = 8500, "from_port" = 8500, "protocol" = "tcp", description = "Consul web UI HTTP" }
    consul-webui-https-tcp = { "to_port" = 8501, "from_port" = 8501, "protocol" = "tcp", description = "Consul web UI HTTPS" }
    consul-dns-tcp         = { "to_port" = 8600, "from_port" = 8600, "protocol" = "tcp", description = "Consul DNS" }
    consul-dns-udp         = { "to_port" = 8600, "from_port" = 8600, "protocol" = "udp", description = "Consul DNS" }
    consul-serf-lan-tcp    = { "to_port" = 8301, "from_port" = 8301, "protocol" = "tcp", description = "Serf LAN" }
    consul-serf-lan-udp    = { "to_port" = 8301, "from_port" = 8301, "protocol" = "udp", description = "Serf LAN" }
    consul-serf-wan-tcp    = { "to_port" = 8302, "from_port" = 8302, "protocol" = "tcp", description = "Serf WAN" }
    consul-serf-wan-udp    = { "to_port" = 8302, "from_port" = 8302, "protocol" = "udp", description = "Serf WAN" }
    # Docker Swarm
    docker-swarm-mngmt-tcp   = { "to_port" = 2377, "from_port" = 2377, "protocol" = "tcp", description = "Docker Swarm cluster management" }
    docker-swarm-node-tcp    = { "to_port" = 7946, "from_port" = 7946, "protocol" = "tcp", description = "Docker Swarm node" }
    docker-swarm-node-udp    = { "to_port" = 7946, "from_port" = 7946, "protocol" = "udp", description = "Docker Swarm node" }
    docker-swarm-overlay-udp = { "to_port" = 4789, "from_port" = 4789, "protocol" = "udp", description = "Docker Swarm Overlay Network Traffic" }
    # DNS
    dns-udp = { "to_port" = 53, "from_port" = 53, "protocol" = "udp", description = "DNS" }
    dns-tcp = { "to_port" = 53, "from_port" = 53, "protocol" = "tcp", description = "DNS" }
    # Etcd
    etcd-client-tcp = { "to_port" = 2379, "from_port" = 2379, "protocol" = "tcp", description = "Etcd Client" }
    etcd-peer-tcp   = { "to_port" = 2380, "from_port" = 2380, "protocol" = "tcp", description = "Etcd Peer" }
    # NTP - Network Time Protocol
    ntp-udp = { "to_port" = 123, "from_port" = 123, "protocol" = "udp", description = "NTP" }
    # Elasticsearch
    elasticsearch-rest-tcp = { "to_port" = 9200, "from_port" = 9200, "protocol" = "tcp", description = "Elasticsearch REST interface" }
    elasticsearch-java-tcp = { "to_port" = 9300, "from_port" = 9300, "protocol" = "tcp", description = "Elasticsearch Java interface" }
    # Grafana
    grafana-tcp = { "to_port" = 3000, "from_port" = 3000, "protocol" = "tcp", description = "Grafana Dashboard" }
    # Graphite Statsd
    graphite-webui    = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", description = "Graphite admin interface" }
    graphite-2003-tcp = { "to_port" = 2003, "from_port" = 2003, "protocol" = "tcp", description = "Carbon receiver plain text" }
    graphite-2004-tcp = { "to_port" = 2004, "from_port" = 2004, "protocol" = "tcp", description = "Carbon receiver pickle" }
    graphite-2023-tcp = { "to_port" = 2023, "from_port" = 2023, "protocol" = "tcp", description = "Carbon aggregator plaintext" }
    graphite-2024-tcp = { "to_port" = 2024, "from_port" = 2024, "protocol" = "tcp", description = "Carbon aggregator pickle" }
    graphite-8080-tcp = { "to_port" = 8080, "from_port" = 8080, "protocol" = "tcp", description = "Graphite gunicorn port" }
    graphite-8125-tcp = { "to_port" = 8125, "from_port" = 8125, "protocol" = "tcp", description = "Statsd TCP" }
    graphite-8125-udp = { "to_port" = 8125, "from_port" = 8125, "protocol" = "udp", description = "Statsd UDP default" }
    graphite-8126-tcp = { "to_port" = 8126, "from_port" = 8126, "protocol" = "tcp", description = "Statsd admin" }
    # HTTP
    http          = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", description = "HTTP" }
    http-tcp      = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", description = "HTTP" }
    http-80-tcp   = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", description = "HTTP" }
    http-8080-tcp = { "to_port" = 8080, "from_port" = 8080, "protocol" = "tcp", description = "HTTP" }
    # HTTPS
    https          = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", description = "HTTPS" }
    https-tcp      = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", description = "HTTPS" }
    https-443-tcp  = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", description = "HTTPS" }
    https-8443-tcp = { "to_port" = 8443, "from_port" = 8443, "protocol" = "tcp", description = "HTTPS" }
    # IPSEC
    ipsec-500-udp  = { "to_port" = 500, "from_port" = 500, "protocol" = "udp", description = "IPSEC ISAKMP" }
    ipsec-4500-udp = { "to_port" = 4500, "from_port" = 4500, "protocol" = "udp", description = "IPSEC NAT-T" }
    # Kafka
    kafka-broker-tcp                   = { "to_port" = 9092, "from_port" = 9092, "protocol" = "tcp", description = "Kafka PLAINTEXT" }
    kafka-broker-9071-tcp              = { "to_port" = 9071, "from_port" = 9071, "protocol" = "tcp", description = "Kafka PLAINTEXT" }
    kafka-broker-tls-tcp               = { "to_port" = 9094, "from_port" = 9094, "protocol" = "tcp", description = "Kafka TLS" }
    kafka-broker-tls-public-tcp        = { "to_port" = 9194, "from_port" = 9194, "protocol" = "tcp", description = "Kafka TLS Public" }
    kafka-broker-sasl-scram-tcp        = { "to_port" = 9096, "from_port" = 9096, "protocol" = "tcp", description = "Kafka SASL/SCRAM" }
    kafka-broker-sasl-scram-public-tcp = { "to_port" = 9196, "from_port" = 9196, "protocol" = "tcp", description = "Kafka SASL/SCRAM Public" }
    kafka-broker-sasl-iam-tcp          = { "to_port" = 9098, "from_port" = 9098, "protocol" = "tcp", description = "Kafka SASL/IAM access control enabled (AWS MSK)" }
    kafka-broker-sasl-iam-public-tcp   = { "to_port" = 9198, "from_port" = 9198, "protocol" = "tcp", description = "Kafka SASL/IAM Public access control enabled (AWS MSK)" }
    kafka-connect-tcp                  = { "to_port" = 8083, "from_port" = 8083, "protocol" = "tcp", description = "Kafka Conect REST API" }
    kafka-jmx-exporter-tcp             = { "to_port" = 11001, "from_port" = 11001, "protocol" = "tcp", description = "Kafka JMX Exporter" }
    kafka-node-exporter-tcp            = { "to_port" = 11002, "from_port" = 11002, "protocol" = "tcp", description = "Kafka Node Exporter" }
    # Kibana
    kibana-tcp = { "to_port" = 5601, "from_port" = 5601, "protocol" = "tcp", description = "Kibana Web Interface" }
    # Kubernetes
    kubernetes-api-tcp = { "to_port" = 6443, "from_port" = 6443, "protocol" = "tcp", description = "Kubernetes API Server" }
    # LDAP
    ldap-tcp = { "to_port" = 389, "from_port" = 389, "protocol" = "tcp", description = "LDAP" }
    # LDAPS
    ldaps-tcp = { "to_port" = 636, "from_port" = 636, "protocol" = "tcp", description = "LDAPS" }
    # Logstash
    logstash-tcp = { "to_port" = 5044, "from_port" = 5044, "protocol" = "tcp", description = "Logstash" }
    # Memcached
    memcached-tcp = { "to_port" = 11211, "from_port" = 11211, "protocol" = "tcp", description = "Memcached" }
    # MinIO
    minio-tcp = { "to_port" = 9000, "from_port" = 9000, "protocol" = "tcp", description = "MinIO" }
    # MongoDB
    mongodb-27017-tcp = { "to_port" = 27017, "from_port" = 27017, "protocol" = "tcp", description = "MongoDB" }
    mongodb-27018-tcp = { "to_port" = 27018, "from_port" = 27018, "protocol" = "tcp", description = "MongoDB shard" }
    mongodb-27019-tcp = { "to_port" = 27019, "from_port" = 27019, "protocol" = "tcp", description = "MongoDB config server" }
    # MySQL
    mysql-tcp = { "to_port" = 3306, "from_port" = 3306, "protocol" = "tcp", description = "MySQL/Aurora" }
    # MSSQL Server
    mssql-tcp           = { "to_port" = 1433, "from_port" = 1433, "protocol" = "tcp", description = "MSSQL Server" }
    mssql-udp           = { "to_port" = 1434, "from_port" = 1434, "protocol" = "udp", description = "MSSQL Browser" }
    mssql-analytics-tcp = { "to_port" = 2383, "from_port" = 2383, "protocol" = "tcp", description = "MSSQL Analytics" }
    mssql-broker-tcp    = { "to_port" = 4022, "from_port" = 4022, "protocol" = "tcp", description = "MSSQL Broker" }
    # NFS/EFS
    nfs-tcp = { "to_port" = 2049, "from_port" = 2049, "protocol" = "tcp", description = "NFS/EFS" }
    # Nomad
    nomad-http-tcp = { "to_port" = 4646, "from_port" = 4646, "protocol" = "tcp", description = "Nomad HTTP" }
    nomad-rpc-tcp  = { "to_port" = 4647, "from_port" = 4647, "protocol" = "tcp", description = "Nomad RPC" }
    nomad-serf-tcp = { "to_port" = 4648, "from_port" = 4648, "protocol" = "tcp", description = "Serf" }
    nomad-serf-udp = { "to_port" = 4648, "from_port" = 4648, "protocol" = "udp", description = "Serf" }
    # OpenVPN
    openvpn-udp       = { "to_port" = 1194, "from_port" = 1194, "protocol" = "udp", description = "OpenVPN" }
    openvpn-tcp       = { "to_port" = 943, "from_port" = 943, "protocol" = "tcp", description = "OpenVPN" }
    openvpn-https-tcp = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", description = "OpenVPN" }
    # PostgreSQL
    postgresql-tcp = { "to_port" = 5432, "from_port" = 5432, "protocol" = "tcp", description = "PostgreSQL" }
    # Puppet
    puppet-tcp   = { "to_port" = 8140, "from_port" = 8140, "protocol" = "tcp", description = "Puppet" }
    puppetdb-tcp = { "to_port" = 8081, "from_port" = 8081, "protocol" = "tcp", description = "PuppetDB" }
    # Prometheus
    prometheus-http-tcp             = { "to_port" = 9090, "from_port" = 9090, "protocol" = "tcp", description = "Prometheus" }
    prometheus-pushgateway-http-tcp = { "to_port" = 9091, "from_port" = 9091, "protocol" = "tcp", description = "Prometheus Pushgateway" }
    # Oracle Database
    oracle-db-tcp = { "to_port" = 1521, "from_port" = 1521, "protocol" = "tcp", description = "Oracle" }
    # Octopus Tentacles
    octopus-tentacle-tcp = { "to_port" = 10933, "from_port" = 10933, "protocol" = "tcp", description = "Octopus Tentacle" }
    # RabbitMQ
    rabbitmq-4369-tcp  = { "to_port" = 4369, "from_port" = 4369, "protocol" = "tcp", description = "RabbitMQ epmd" }
    rabbitmq-5671-tcp  = { "to_port" = 5671, "from_port" = 5671, "protocol" = "tcp", description = "RabbitMQ" }
    rabbitmq-5672-tcp  = { "to_port" = 5672, "from_port" = 5672, "protocol" = "tcp", description = "RabbitMQ" }
    rabbitmq-15672-tcp = { "to_port" = 15672, "from_port" = 15672, "protocol" = "tcp", description = "RabbitMQ" }
    rabbitmq-25672-tcp = { "to_port" = 25672, "from_port" = 25672, "protocol" = "tcp", description = "RabbitMQ" }
    # RDP
    rdp-tcp = { "to_port" = 3389, "from_port" = 3389, "protocol" = "tcp", description = "Remote Desktop" }
    rdp-udp = { "to_port" = 3389, "from_port" = 3389, "protocol" = "udp", description = "Remote Desktop" }
    # Redis
    redis-tcp = { "to_port" = 6379, "from_port" = 6379, "protocol" = "tcp", description = "Redis" }
    # Redshift
    redshift-tcp = { "to_port" = 5439, "from_port" = 5439, "protocol" = "tcp", description = "Redshift" }
    # SaltStack
    saltstack-tcp = { "to_port" = 4505, "from_port" = 4506, "protocol" = "tcp", description = "SaltStack" }
    # SMTP
    smtp-tcp                 = { "to_port" = 25, "from_port" = 25, "protocol" = "tcp", description = "SMTP" }
    smtp-submission-587-tcp  = { "to_port" = 587, "from_port" = 587, "protocol" = "tcp", description = "SMTP Submission" }
    smtp-submission-2587-tcp = { "to_port" = 2587, "from_port" = 2587, "protocol" = "tcp", description = "SMTP Submission" }
    smtps-465-tcp            = { "to_port" = 465, "from_port" = 465, "protocol" = "tcp", description = "SMTPS" }
    smtps-2456-tcp           = { "to_port" = 2465, "from_port" = 2465, "protocol" = "tcp", description = "SMTPS" }
    # Solr
    solr-tcp = { "to_port" = 8983, "from_port" = 8987, "protocol" = "tcp", description = "Solr" }
    # Splunk
    splunk-indexer-tcp = { "to_port" = 9997, "from_port" = 9997, "protocol" = "tcp", description = "Splunk indexer" }
    splunk-web-tcp     = { "to_port" = 8000, "from_port" = 8000, "protocol" = "tcp", description = "Splunk Web" }
    splunk-splunkd-tcp = { "to_port" = 8089, "from_port" = 8089, "protocol" = "tcp", description = "Splunkd" }
    splunk-hec-tcp     = { "to_port" = 8088, "from_port" = 8088, "protocol" = "tcp", description = "Splunk HEC" }
    # Squid
    squid-proxy-tcp = { "to_port" = 3128, "from_port" = 3128, "protocol" = "tcp", description = "Squid default proxy" }
    # SSH
    ssh-tcp = { "to_port" = 22, "from_port" = 22, "protocol" = "tcp", description = "SSH" }
    # Storm
    storm-nimbus-tcp     = { "to_port" = 6627, "from_port" = 6627, "protocol" = "tcp", description = "Nimbus" }
    storm-ui-tcp         = { "to_port" = 8080, "from_port" = 8080, "protocol" = "tcp", description = "Storm UI" }
    storm-supervisor-tcp = { "to_port" = 6700, "from_port" = 6703, "protocol" = "tcp", description = "Supervisor" }
    # Wazuh
    wazuh-server-agent-connection-tcp = { "to_port" = 1514, "from_port" = 1514, "protocol" = "tcp", description = "Agent connection service(TCP)" }
    wazuh-server-agent-connection-udp = { "to_port" = 1514, "from_port" = 1514, "protocol" = "udp", description = "Agent connection service(UDP)" }
    wazuh-server-agent-enrollment     = { "to_port" = 1515, "from_port" = 1515, "protocol" = "tcp", description = "Agent enrollment service" }
    wazuh-server-agent-cluster-daemon = { "to_port" = 1516, "from_port" = 1516, "protocol" = "tcp", description = "Wazuh cluster daemon" }
    wazuh-server-syslog-collector-tcp = { "to_port" = 514, "from_port" = 514, "protocol" = "tcp", description = "Wazuh Syslog collector(TCP)" }
    wazuh-server-syslog-collector-udp = { "to_port" = 514, "from_port" = 514, "protocol" = "udp", description = "Wazuh Syslog collector(UDP)" }
    wazuh-server-restful-api          = { "to_port" = 55000, "from_port" = 55000, "protocol" = "tcp", description = "Wazuh server RESTful API" }
    wazuh-indexer-restful-api         = { "to_port" = 9200, "from_port" = 9200, "protocol" = "tcp", description = "Wazuh indexer RESTful API" }
    wazuh-dashboard                   = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", description = "Wazuh web user interface" }
    # Web
    web-jmx-tcp = { "to_port" = 1099, "from_port" = 1099, "protocol" = "tcp", description = "JMX" }
    # WinRM
    winrm-http-tcp  = { "to_port" = 5985, "from_port" = 5985, "protocol" = "tcp", description = "WinRM HTTP" }
    winrm-https-tcp = { "to_port" = 5986, "from_port" = 5986, "protocol" = "tcp", description = "WinRM HTTPS" }
    # Zabbix
    zabbix-server = { "to_port" = 10051, "from_port" = 10051, "protocol" = "tcp", description = "Zabbix Server" }
    zabbix-proxy  = { "to_port" = 10051, "from_port" = 10051, "protocol" = "tcp", description = "Zabbix Proxy" }
    zabbix-agent  = { "to_port" = 10050, "from_port" = 10050, "protocol" = "tcp", description = "Zabbix Agent" }
    # Zipkin
    zipkin-admin-tcp       = { "to_port" = 9990, "from_port" = 9990, "protocol" = "tcp", description = "Zipkin Admin port collector" }
    zipkin-admin-query-tcp = { "to_port" = 9901, "from_port" = 9901, "protocol" = "tcp", description = "Zipkin Admin port query" }
    zipkin-admin-web-tcp   = { "to_port" = 9991, "from_port" = 9991, "protocol" = "tcp", description = "Zipkin Admin port web" }
    zipkin-query-tcp       = { "to_port" = 9411, "from_port" = 9411, "protocol" = "tcp", description = "Zipkin query port" }
    zipkin-web-tcp         = { "to_port" = 8080, "from_port" = 8080, "protocol" = "tcp", description = "Zipkin web port" }
    # Zookeeper
    zookeeper-2181-tcp     = { "to_port" = 2181, "from_port" = 2181, "protocol" = "tcp", description = "Zookeeper" }
    zookeeper-2182-tls-tcp = { "to_port" = 2182, "from_port" = 2182, "protocol" = "tcp", description = "Zookeeper TLS (MSK specific)" }
    zookeeper-2888-tcp     = { "to_port" = 2888, "from_port" = 2888, "protocol" = "tcp", description = "Zookeeper" }
    zookeeper-3888-tcp     = { "to_port" = 3888, "from_port" = 3888, "protocol" = "tcp", description = "Zookeeper" }
    zookeeper-jmx-tcp      = { "to_port" = 7199, "from_port" = 7199, "protocol" = "tcp", description = "JMX" }
    # Open all ports & protocols
    all-all       = { "to_port" = 0, "from_port" = 0, "protocol" = "all", description = "All protocols" }
    all-tcp       = { "to_port" = 0, "from_port" = 65535, "protocol" = "tcp", description = "All TCP ports" }
    all-udp       = { "to_port" = 0, "from_port" = 65535, "protocol" = "udp", description = "All UDP ports" }
    all-icmp      = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", description = "All IPV4 ICMP" }
    all-ipv6-icmp = { "to_port" = 0, "from_port" = 0, "protocol" = 58, description = "All IPV6 ICMP" }
  }
}
```

</details>

**Common Rules:**

<details><summary>Click to show</summary>

```hcl
# Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
# All = 0, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58
locals {
  common_rule_aliases_internal = {
    # common rules with "from" are intended to be used with ingress module arguments
    all-all-self         = { "to_port" = 0, "from_port" = 0, "protocol" = "all", self = true, description = "All protocols self" }
    https-443-tcp-public = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTPS from public" }
    https-tcp-public     = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTPS from public" }
    https-public         = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTPS from public" }
    http-80-tcp-public   = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTP from public" }
    http-tcp-public      = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTP from public" }
    http-public          = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTP from public" }
    all-icmp-public      = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All IPV4 ICMP from public" }
    all-ping-public      = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All IPV4 ICMP from public" }
    all-ipv6-icmp-public = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All IPV6 ICMP from public" }
    all-ipv6-ping-public = { "to_port" = 0, "from_port" = 0, "protocol" = 58, cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All IPV6 ICMP from public" }

    # common rules with "to" are intended to be used with egress module arguments
    all-all-self   = { "to_port" = 0, "from_port" = 0, "protocol" = "all", self = true, description = "All protocols to self" }
    all-all-public = { "to_port" = 0, "from_port" = 0, "protocol" = "all", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All to public" }
  }

  common_rule_aliases_with_type_annotation_internal = {
    # common rules with "from" are intended to be used with ingress module arguments
    all-all-from-self         = local.common_rule_aliases_internal["all-all-self"]
    https-443-tcp-from-public = local.common_rule_aliases_internal["https-443-tcp-public"]
    https-tcp-from-public     = local.common_rule_aliases_internal["https-tcp-public"]
    https-from-public         = local.common_rule_aliases_internal["https-public"]
    http-80-tcp-from-public   = local.common_rule_aliases_internal["http-80-tcp-public"]
    http-tcp-from-public      = local.common_rule_aliases_internal["http-tcp-public"]
    http-from-public          = local.common_rule_aliases_internal["http-public"]
    all-icmp-from-public      = local.common_rule_aliases_internal["all-icmp-public"]
    all-ping-from-public      = local.common_rule_aliases_internal["all-ping-public"]

    # common rules with "to" are intended to be used with egress module arguments
    all-all-to-self   = local.common_rule_aliases_internal["all-all-self"]
    all-all-to-public = local.common_rule_aliases_internal["all-all-public"]
  }

  common_rule_aliases = merge(
    local.common_rule_aliases_internal,
    local.common_rule_aliases_with_type_annotation_internal
  )
}
```

</details>

## Examples

Create a Security Group with the following rules:

- Ingress `https-443-tcp` managed rules (ipv4 and ipv6)
- Egress `all-all-to-public` common rule

```hcl
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 2.0.1"

  name        = local.name
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  # recommended
  unpack = true

  ingress = [
    {
      rule             = "https-443-tcp"
      cidr_blocks      = [data.aws_vpc.default.cidr_block]
      ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]

  egress = [
    { rule = "all-all-to-public" }
  ]
}
```

</details>

Please see the full examples for more information:

- [Basic Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/basic)

- [Complete Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/complete)

- [Customer Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/customer)

- [Managed Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/managed)

- [Common Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/common)

- [Matrix Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/matrix)

- [Computed Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/computed)

- [Name Prefix Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/name_prefix)

- [Rules Only Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/rules_only)

- [Unpack Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/unpack)

## Key Concepts

| Terminology | Description |
|---|---|
| **AWS Security Group Rule** | The Security Group (SG) rule resource (ingress/egress). |
| **Customer Rule** | A module rule where the customer explicitly declares all of the SG rule arguments. <br/><br/>These rules are analogous to [AWS customer policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#customer-managed-policies) for IAM. |
| **Managed Rule** | A module rule alias for a managed/[predefined](https://github.com/terraform-aws-modules/terraform-aws-security-group#security-group-with-predefined-rules) group of `from_port`, `to_port`, and `protocol` arguments. <br/><br/> E.g. `https-443-tcp`/`https-tcp`, `postgresql-tcp`, `ssh-tcp`, and `all-all`. Please see [alias_managed_rules.tf](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/alias_managed_rules.tf) for the complete list of managed rules. <br/><br/>These rules are analogous to [AWS managed policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#aws-managed-policies) for IAM. |
| **Common Rule** | A module rule alias for a common scenario where all SG rule arguments except for `type` are known and managed by the rule. <br/><br/>E.g. `https-443-tcp-public`/`https-tcp-from-public`, and `all-all-to-public`, `all-all-from-self` just to name a few. Please see [alias_common_rules.tf](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/alias_common_rules.tf) for the complete list of common rules. |
| **Matrix Rules** | A map of module rule(s) and source(s)/destination(s) representing the multi-dimensional matrix rules to be applied. <br/><br/>These rules act like a [multi-dimension matrix in Github Actions](https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs#example-using-a-multi-dimension-matrix).|
| **Computed Rule** | A special module rule that works with [unknown values](https://github.com/hashicorp/terraform/issues/30937) such as: `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc. All types of module rules are supported. |
| **Packed Rules** | The arguments for a single `aws_security_group_rule` resource are considered "packed" when the resulting EC2 API creates many security group rules. |
| **Unpacked Rules** | The arguments for a single `aws_security_group_rule` resource are considered "unpacked" when the resulting EC2 API creates exactly one security group rule. |

## Rule Argument Precedence

This module uses the [`try` function](https://developer.hashicorp.com/terraform/language/functions/try) to implement argument precedence.

| Argument | Precedence (most -> least) |
|---|---|
| **description** | `rule.description` -> `rule_alias.description` -> `var.default_rule_description` |
| **from_port** | `rule.from_port (customer)` -> `rule_alias.from_port (managed/common)` |
| **to_port** | `rule.to_port (customer)` -> `rule_alias.to_port (managed/common)` |
| **protocol** | `rule.protocol (customer)` -> `rule_alias.protocol (managed/common)` |
| **cidr_blocks** | `rule.cidr_blocks` -> `rule_alias.cidr_blocks (common)` |
| **ipv6_cidr_blocks** | `rule.ipv6_cidr_blocks` -> `rule_alias.ipv6_cidr_blocks (common)` |
| **prefix_list_ids** | `rule.prefix_list_ids` -> `rule_alias.prefix_list_ids (common)` |
| **source_security_group_id** | `rule.source_security_group_id` -> `rule_alias.source_security_group_id (common)` |
| **self** | `rule.self` -> `rule_alias.self (common)` |

## Tests

Run Terratest using the [Makefile](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/Makefile) targets:

1. `make setup`
2. `make tests`

### Results

```
Terratest Suite (Module v2.0.1) (Terraform v1.3.1)
--- PASS: TestTerraformBasicExample (24.09s)
--- PASS: TestTerraformCompleteExample (42.17s)
--- PASS: TestTerraformCustomerRulesExample (29.91s)
--- PASS: TestTerraformManagedRulesExample (30.58s)
--- PASS: TestTerraformCommonRulesExample (24.25s)
--- PASS: TestTerraformMatrixRulesExample (30.92s)
--- PASS: TestTerraformComputedRulesExample (37.95s)
--- PASS: TestTerraformNamePrefixExample (20.94s)
--- PASS: TestTerraformRulesOnlyExample (20.53s)
--- PASS: TestTerraformUnpackRulesExample (44.54s)
```

## Makefile Targets

```
help                 This help.
build                Build docker dev image
run                  Run docker dev container
setup                Setup project
lint                 Lint with pre-commit and render docs
lint-all             Lint all files with pre-commit and render docs
tests                Tests with Terratest
test-basic           Test the basic example
test-complete        Test the complete example
test-customer        Test the customer example
test-managed         Test the managed example
test-common          Test the common example
test-matrix          Test the matrix example
test-computed        Test the computed example
test-rules-only      Test the rules_only example
test-name-prefix     Test the name_prefix example
test-unpack          Test the unpack example
clean                Clean project
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.29 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_egress_unpack"></a> [egress\_unpack](#module\_egress\_unpack) | ./modules/null_unpack_rules | n/a |
| <a name="module_ingress_unpack"></a> [ingress\_unpack](#module\_ingress\_unpack) | ./modules/null_unpack_rules | n/a |
| <a name="module_matrix_egress_repack"></a> [matrix\_egress\_repack](#module\_matrix\_egress\_repack) | ./modules/null_repack_matrix_rules | n/a |
| <a name="module_matrix_egress_unpack"></a> [matrix\_egress\_unpack](#module\_matrix\_egress\_unpack) | ./modules/null_unpack_rules | n/a |
| <a name="module_matrix_ingress_repack"></a> [matrix\_ingress\_repack](#module\_matrix\_ingress\_repack) | ./modules/null_repack_matrix_rules | n/a |
| <a name="module_matrix_ingress_unpack"></a> [matrix\_ingress\_unpack](#module\_matrix\_ingress\_unpack) | ./modules/null_unpack_rules | n/a |
## Resources

| Name | Type |
|------|------|
| [aws_security_group.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.self_with_name_prefix](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.computed_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.computed_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.computed_matrix_egress_with_cidr_blocks_and_prefix_list_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.computed_matrix_egress_with_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.computed_matrix_egress_with_source_security_group_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.computed_matrix_ingress_with_cidr_blocks_and_prefix_list_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.computed_matrix_ingress_with_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.computed_matrix_ingress_with_source_security_group_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.matrix_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.matrix_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_computed_egress"></a> [computed\_egress](#input\_computed\_egress) | The security group egress rules that contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). Can be either customer, managed, or common rule. | `any` | `[]` | no |
| <a name="input_computed_ingress"></a> [computed\_ingress](#input\_computed\_ingress) | The security group ingress rules that contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). Can be either customer, managed, or common rule. | `any` | `[]` | no |
| <a name="input_computed_matrix_egress"></a> [computed\_matrix\_egress](#input\_computed\_matrix\_egress) | A map of module rule(s) and destinations(s) representing the multi-dimensional matrix egress rules. The matrix may contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). | `any` | `{}` | no |
| <a name="input_computed_matrix_ingress"></a> [computed\_matrix\_ingress](#input\_computed\_matrix\_ingress) | A map of module rule(s) and source(s) representing the multi-dimensional matrix ingress rules. The matrix may contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create security group and all rules | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create security group and all rules. | `bool` | `true` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | Time to wait for a security group to be created. | `string` | `"10m"` | no |
| <a name="input_debug"></a> [debug](#input\_debug) | Whether to output debug information on local for\_each loops. | `bool` | `false` | no |
| <a name="input_default_rule_description"></a> [default\_rule\_description](#input\_default\_rule\_description) | The default security group rule description. | `string` | `"managed by Terraform"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | Time to wait for a security group to be deleted. | `string` | `"15m"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional, Forces new resource) Security group description. Defaults to Managed by Terraform. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags. | `string` | `null` | no |
| <a name="input_egress"></a> [egress](#input\_egress) | The security group egress rules. Can be either customer, managed, or common rule. | `any` | `[]` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | The security group ingress rules. Can be either customer, managed, or common rule. | `any` | `[]` | no |
| <a name="input_matrix_egress"></a> [matrix\_egress](#input\_matrix\_egress) | A map of module rule(s) and destinations(s) representing the multi-dimensional matrix egress rules. | `any` | `{}` | no |
| <a name="input_matrix_ingress"></a> [matrix\_ingress](#input\_matrix\_ingress) | A map of module rule(s) and source(s) representing the multi-dimensional matrix ingress rules. | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional, Forces new resource) Name of the security group. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name. | `string` | `null` | no |
| <a name="input_name_prefix_separator"></a> [name\_prefix\_separator](#input\_name\_prefix\_separator) | (Optional, Only used with name\_prefix) The separator between the name\_prefix and generated suffix. | `string` | `"-"` | no |
| <a name="input_revoke_rules_on_delete"></a> [revoke\_rules\_on\_delete](#input\_revoke\_rules\_on\_delete) | (Optional) Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. This is normally not needed, however certain AWS services such as Elastic Map Reduce may automatically add required rules to security groups used with the service, and those rules may contain a cyclic dependency that prevent the security groups from being destroyed without removing the dependency first. Default false. | `string` | `null` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | ID of existing security group whose rules we will manage. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `null` | no |
| <a name="input_unpack"></a> [unpack](#input\_unpack) | Whether to unpack security group rule arguments. Unpacking will prevent unwanted security group rule updates that regularly occur when arguments are packed together. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Optional, Forces new resource) VPC ID. | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_debug"></a> [debug](#output\_debug) | Debug information on local for\_each loops. |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | The security group attributes. |
| <a name="output_security_group_egress_rules"></a> [security\_group\_egress\_rules](#output\_security\_group\_egress\_rules) | The security group egress rules. |
| <a name="output_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#output\_security\_group\_ingress\_rules) | The security group ingress rules. |

## Acknowledgments

This modules aims to improve on the venerable [terraform-aws-modules/terraform-aws-security-group](https://github.com/terraform-aws-modules/terraform-aws-security-group) module authored by [Anton Babenko](https://github.com/antonbabenko). It does so by:

- Reduce the amount of code with [`for` expressions](https://www.terraform.io/language/expressions/for). The core functionality found in the [main.tf](https://github.com/aidanmelen/terraform-aws-security-group-v2/blob/main/main.tf) is ~100 lines.

- Follow DRY principals by using [Conditionally Omitted Arguments](https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements#conditionally-omitted-arguments) AKA nullables.

- Prevent Service interruptions by [unpacking](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/unpack) packed arguments provided by the user.

- A simplified interface for matrix functionality that works with all module rule types and computed rules.

- Dynamically create customer, managed and common security group rule resources with [`for_each` meta-arguments](https://www.terraform.io/language/meta-arguments/for_each). `for_each` has two advantages over `count`:

1. Resources created with `for_each` are identified by a list of string values instead of by index with `count`.
2. If an element is removed from the middle of the list, every security group rule after that element would see its values change, resulting in more remote object changes than intended. Using `for_each` gives the same flexibility without the extra churn. Please see [When to Use for_each Instead of count](https://www.terraform.io/language/meta-arguments/count#when-to-use-for_each-instead-of-count) for more information.

- Computed security group rule resources must use `count` due to the [Limitations on values used in `for_each`](https://www.terraform.io/language/meta-arguments/for_each#limitations-on-values-used-in-for_each). However, this implementation uses the `length` function to dynamically set the `count` which is an improvement from the `number_of_computed_` variables used by the [terraform-aws-security-group](https://github.com/terraform-aws-modules/terraform-aws-security-group#note-about-value-of-count-cannot-be-computed) module. Please see [#30937](https://github.com/hashicorp/terraform/issues/30937) for more information on unknown values.

- Encourage the security best practice of restrictive rules by making users **opt-in** to common rules like `all-all-to-public`. This approach is consistent with the implementation of the `aws_security_group_rule` resource as described in the [NOTE on Egress rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#basic-usage). Moreover, please see [no-public-egress-sgr](https://aquasecurity.github.io/tfsec/v0.61.3/checks/aws/vpc/no-public-egress-sgr/) for more information.

- Improve security by making it easy for users to declare granular customer, managed, common, matrix, and computed security group rules.

- Test examples with [Terratest](https://terratest.gruntwork.io/).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-kubernetes-confluent-platform/blob/main/LICENSE) for full details.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
