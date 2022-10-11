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
