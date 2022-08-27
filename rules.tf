# Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
# All = -1, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58
locals {
  rules = {
    # ActiveMQ
    activemq-5671-tcp  = { "to_port" = 5671, "from_port" = 5671, "protocol" = "tcp" }
    activemq-8883-tcp  = { "to_port" = 8883, "from_port" = 8883, "protocol" = "tcp" }
    activemq-61614-tcp = { "to_port" = 61614, "from_port" = 61614, "protocol" = "tcp" }
    activemq-61617-tcp = { "to_port" = 61617, "from_port" = 61617, "protocol" = "tcp" }
    activemq-61619-tcp = { "to_port" = 61619, "from_port" = 61619, "protocol" = "tcp" }
    # Alert Manager
    alertmanager-9093-tcp = { "to_port" = 9093, "from_port" = 9093, "protocol" = "tcp" }
    alertmanager-9094-tcp = { "to_port" = 9094, "from_port" = 9094, "protocol" = "tcp" }
    # Carbon relay
    carbon-line-in-tcp = { "to_port" = 2003, "from_port" = 2003, "protocol" = "tcp" }
    carbon-line-in-udp = { "to_port" = 2003, "from_port" = 2003, "protocol" = "udp" }
    carbon-pickle-tcp  = { "to_port" = 2013, "from_port" = 2013, "protocol" = "tcp" }
    carbon-pickle-udp  = { "to_port" = 2013, "from_port" = 2013, "protocol" = "udp" }
    carbon-admin-tcp   = { "to_port" = 2004, "from_port" = 2004, "protocol" = "tcp" }
    carbon-gui-udp     = { "to_port" = 8081, "from_port" = 8081, "protocol" = "tcp" }
    # Cassandra
    cassandra-clients-tcp        = { "to_port" = 9042, "from_port" = 9042, "protocol" = "tcp" }
    cassandra-thrift-clients-tcp = { "to_port" = 9160, "from_port" = 9160, "protocol" = "tcp" }
    cassandra-jmx-tcp            = { "to_port" = 7199, "from_port" = 7199, "protocol" = "tcp" }
    # Consul
    consul-tcp             = { "to_port" = 8300, "from_port" = 8300, "protocol" = "tcp" }
    consul-grpc-tcp        = { "to_port" = 8502, "from_port" = 8502, "protocol" = "tcp" }
    consul-webui-http-tcp  = { "to_port" = 8500, "from_port" = 8500, "protocol" = "tcp" }
    consul-webui-https-tcp = { "to_port" = 8501, "from_port" = 8501, "protocol" = "tcp" }
    consul-dns-tcp         = { "to_port" = 8600, "from_port" = 8600, "protocol" = "tcp" }
    consul-dns-udp         = { "to_port" = 8600, "from_port" = 8600, "protocol" = "udp" }
    consul-serf-lan-tcp    = { "to_port" = 8301, "from_port" = 8301, "protocol" = "tcp" }
    consul-serf-lan-udp    = { "to_port" = 8301, "from_port" = 8301, "protocol" = "udp" }
    consul-serf-wan-tcp    = { "to_port" = 8302, "from_port" = 8302, "protocol" = "tcp" }
    consul-serf-wan-udp    = { "to_port" = 8302, "from_port" = 8302, "protocol" = "udp" }
    # Docker Swarm
    docker-swarm-mngmt-tcp   = { "to_port" = 2377, "from_port" = 2377, "protocol" = "tcp" }
    docker-swarm-node-tcp    = { "to_port" = 7946, "from_port" = 7946, "protocol" = "tcp" }
    docker-swarm-node-udp    = { "to_port" = 7946, "from_port" = 7946, "protocol" = "udp" }
    docker-swarm-overlay-udp = { "to_port" = 4789, "from_port" = 4789, "protocol" = "udp" }
    # DNS
    dns-udp = { "to_port" = 53, "from_port" = 53, "protocol" = "udp" }
    dns-tcp = { "to_port" = 53, "from_port" = 53, "protocol" = "tcp" }
    # Etcd
    etcd-client-tcp = { "to_port" = 2379, "from_port" = 2379, "protocol" = "tcp" }
    etcd-peer-tcp   = { "to_port" = 2380, "from_port" = 2380, "protocol" = "tcp" }
    # NTP - Network Time Protocol
    ntp-udp = { "to_port" = 123, "from_port" = 123, "protocol" = "udp" }
    # Elasticsearch
    elasticsearch-rest-tcp = { "to_port" = 9200, "from_port" = 9200, "protocol" = "tcp" }
    elasticsearch-java-tcp = { "to_port" = 9300, "from_port" = 9300, "protocol" = "tcp" }
    # Grafana
    grafana-tcp = { "to_port" = 3000, "from_port" = 3000, "protocol" = "tcp" }
    # Graphite Statsd
    graphite-webui    = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp" }
    graphite-2003-tcp = { "to_port" = 2003, "from_port" = 2003, "protocol" = "tcp" }
    graphite-2004-tcp = { "to_port" = 2004, "from_port" = 2004, "protocol" = "tcp" }
    graphite-2023-tcp = { "to_port" = 2023, "from_port" = 2023, "protocol" = "tcp" }
    graphite-2024-tcp = { "to_port" = 2024, "from_port" = 2024, "protocol" = "tcp" }
    graphite-8080-tcp = { "to_port" = 8080, "from_port" = 8080, "protocol" = "tcp" }
    graphite-8125-tcp = { "to_port" = 8125, "from_port" = 8125, "protocol" = "tcp" }
    graphite-8125-udp = { "to_port" = 8125, "from_port" = 8125, "protocol" = "udp" }
    graphite-8126-tcp = { "to_port" = 8126, "from_port" = 8126, "protocol" = "tcp" }
    # HTTP
    http-80-tcp   = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp" }
    http-8080-tcp = { "to_port" = 8080, "from_port" = 8080, "protocol" = "tcp" }
    # HTTPS
    https-443-tcp  = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp" }
    https-8443-tcp = { "to_port" = 8443, "from_port" = 8443, "protocol" = "tcp" }
    # IPSEC
    ipsec-500-udp  = { "to_port" = 500, "from_port" = 500, "protocol" = "udp" }
    ipsec-4500-udp = { "to_port" = 4500, "from_port" = 4500, "protocol" = "udp" }
    # Kafka
    kafka-broker-tcp                   = { "to_port" = 9092, "from_port" = 9092, "protocol" = "tcp" }
    kafka-broker-tls-tcp               = { "to_port" = 9094, "from_port" = 9094, "protocol" = "tcp" }
    kafka-broker-tls-public-tcp        = { "to_port" = 9194, "from_port" = 9194, "protocol" = "tcp" }
    kafka-broker-sasl-scram-tcp        = { "to_port" = 9096, "from_port" = 9096, "protocol" = "tcp" }
    kafka-broker-sasl-scram-public-tcp = { "to_port" = 9196, "from_port" = 9196, "protocol" = "tcp" }
    kafka-broker-sasl-iam-tcp          = { "to_port" = 9098, "from_port" = 9098, "protocol" = "tcp" }
    kafka-broker-sasl-iam-public-tcp   = { "to_port" = 9198, "from_port" = 9198, "protocol" = "tcp" }
    kafka-jmx-exporter-tcp             = { "to_port" = 11001, "from_port" = 11001, "protocol" = "tcp" }
    kafka-node-exporter-tcp            = { "to_port" = 11002, "from_port" = 11002, "protocol" = "tcp" }
    # Kibana
    kibana-tcp = { "to_port" = 5601, "from_port" = 5601, "protocol" = "tcp" }
    # Kubernetes
    kubernetes-api-tcp = { "to_port" = 6443, "from_port" = 6443, "protocol" = "tcp" }
    # LDAP
    ldap-tcp = { "to_port" = 389, "from_port" = 389, "protocol" = "tcp" }
    # LDAPS
    ldaps-tcp = { "to_port" = 636, "from_port" = 636, "protocol" = "tcp" }
    # Logstash
    logstash-tcp = { "to_port" = 5044, "from_port" = 5044, "protocol" = "tcp" }
    # Memcached
    memcached-tcp = { "to_port" = 11211, "from_port" = 11211, "protocol" = "tcp" }
    # MinIO
    minio-tcp = { "to_port" = 9000, "from_port" = 9000, "protocol" = "tcp" }
    # MongoDB
    mongodb-27017-tcp = { "to_port" = 27017, "from_port" = 27017, "protocol" = "tcp" }
    mongodb-27018-tcp = { "to_port" = 27018, "from_port" = 27018, "protocol" = "tcp" }
    mongodb-27019-tcp = { "to_port" = 27019, "from_port" = 27019, "protocol" = "tcp" }
    # MySQL
    mysql-tcp = { "to_port" = 3306, "from_port" = 3306, "protocol" = "tcp" }
    # MSSQL Server
    mssql-tcp           = { "to_port" = 1433, "from_port" = 1433, "protocol" = "tcp" }
    mssql-udp           = { "to_port" = 1434, "from_port" = 1434, "protocol" = "udp" }
    mssql-analytics-tcp = { "to_port" = 2383, "from_port" = 2383, "protocol" = "tcp" }
    mssql-broker-tcp    = { "to_port" = 4022, "from_port" = 4022, "protocol" = "tcp" }
    # NFS/EFS
    nfs-tcp = { "to_port" = 2049, "from_port" = 2049, "protocol" = "tcp" }
    # Nomad
    nomad-http-tcp = { "to_port" = 4646, "from_port" = 4646, "protocol" = "tcp" }
    nomad-rpc-tcp  = { "to_port" = 4647, "from_port" = 4647, "protocol" = "tcp" }
    nomad-serf-tcp = { "to_port" = 4648, "from_port" = 4648, "protocol" = "tcp" }
    nomad-serf-udp = { "to_port" = 4648, "from_port" = 4648, "protocol" = "udp" }
    # OpenVPN
    openvpn-udp       = { "to_port" = 1194, "from_port" = 1194, "protocol" = "udp" }
    openvpn-tcp       = { "to_port" = 943, "from_port" = 943, "protocol" = "tcp" }
    openvpn-https-tcp = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp" }
    # PostgreSQL
    postgresql-tcp = { "to_port" = 5432, "from_port" = 5432, "protocol" = "tcp" }
    # Puppet
    puppet-tcp   = { "to_port" = 8140, "from_port" = 8140, "protocol" = "tcp" }
    puppetdb-tcp = { "to_port" = 8081, "from_port" = 8081, "protocol" = "tcp" }
    # Prometheus
    prometheus-http-tcp             = { "to_port" = 9090, "from_port" = 9090, "protocol" = "tcp" }
    prometheus-pushgateway-http-tcp = { "to_port" = 9091, "from_port" = 9091, "protocol" = "tcp" }
    # Oracle Database
    oracle-db-tcp = { "to_port" = 1521, "from_port" = 1521, "protocol" = "tcp" }
    # Octopus Tentacles
    octopus-tentacle-tcp = { "to_port" = 10933, "from_port" = 10933, "protocol" = "tcp" }
    # RabbitMQ
    rabbitmq-4369-tcp  = { "to_port" = 4369, "from_port" = 4369, "protocol" = "tcp" }
    rabbitmq-5671-tcp  = { "to_port" = 5671, "from_port" = 5671, "protocol" = "tcp" }
    rabbitmq-5672-tcp  = { "to_port" = 5672, "from_port" = 5672, "protocol" = "tcp" }
    rabbitmq-15672-tcp = { "to_port" = 15672, "from_port" = 15672, "protocol" = "tcp" }
    rabbitmq-25672-tcp = { "to_port" = 25672, "from_port" = 25672, "protocol" = "tcp" }
    # RDP
    rdp-tcp = { "to_port" = 3389, "from_port" = 3389, "protocol" = "tcp" }
    rdp-udp = { "to_port" = 3389, "from_port" = 3389, "protocol" = "udp" }
    # Redis
    redis-tcp = { "to_port" = 6379, "from_port" = 6379, "protocol" = "tcp" }
    # Redshift
    redshift-tcp = { "to_port" = 5439, "from_port" = 5439, "protocol" = "tcp" }
    # SaltStack
    saltstack-tcp = { "to_port" = 4505, "from_port" = 4506, "protocol" = "tcp" }
    # SMTP
    smtp-tcp                 = { "to_port" = 25, "from_port" = 25, "protocol" = "tcp" }
    smtp-submission-587-tcp  = { "to_port" = 587, "from_port" = 587, "protocol" = "tcp" }
    smtp-submission-2587-tcp = { "to_port" = 2587, "from_port" = 2587, "protocol" = "tcp" }
    smtps-465-tcp            = { "to_port" = 465, "from_port" = 465, "protocol" = "tcp" }
    smtps-2456-tcp           = { "to_port" = 2465, "from_port" = 2465, "protocol" = "tcp" }
    # Solr
    solr-tcp = { "to_port" = 8983, "from_port" = 8987, "protocol" = "tcp" }
    # Splunk
    splunk-indexer-tcp = { "to_port" = 9997, "from_port" = 9997, "protocol" = "tcp" }
    splunk-web-tcp     = { "to_port" = 8000, "from_port" = 8000, "protocol" = "tcp" }
    splunk-splunkd-tcp = { "to_port" = 8089, "from_port" = 8089, "protocol" = "tcp" }
    splunk-hec-tcp     = { "to_port" = 8088, "from_port" = 8088, "protocol" = "tcp" }
    # Squid
    squid-proxy-tcp = { "to_port" = 3128, "from_port" = 3128, "protocol" = "tcp" }
    # SSH
    ssh-tcp = { "to_port" = 22, "from_port" = 22, "protocol" = "tcp" }
    # Storm
    storm-nimbus-tcp     = { "to_port" = 6627, "from_port" = 6627, "protocol" = "tcp" }
    storm-ui-tcp         = { "to_port" = 8080, "from_port" = 8080, "protocol" = "tcp" }
    storm-supervisor-tcp = { "to_port" = 6700, "from_port" = 6703, "protocol" = "tcp" }
    # Wazuh
    wazuh-server-agent-connection-tcp = { "to_port" = 1514, "from_port" = 1514, "protocol" = "tcp" }
    wazuh-server-agent-connection-udp = { "to_port" = 1514, "from_port" = 1514, "protocol" = "udp" }
    wazuh-server-agent-enrollment     = { "to_port" = 1515, "from_port" = 1515, "protocol" = "tcp" }
    wazuh-server-agent-cluster-daemon = { "to_port" = 1516, "from_port" = 1516, "protocol" = "tcp" }
    wazuh-server-syslog-collector-tcp = { "to_port" = 514, "from_port" = 514, "protocol" = "tcp" }
    wazuh-server-syslog-collector-udp = { "to_port" = 514, "from_port" = 514, "protocol" = "udp" }
    wazuh-server-restful-api          = { "to_port" = 55000, "from_port" = 55000, "protocol" = "tcp" }
    wazuh-indexer-restful-api         = { "to_port" = 9200, "from_port" = 9200, "protocol" = "tcp" }
    wazuh-dashboard                   = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp" }
    # Web
    web-jmx-tcp = { "to_port" = 1099, "from_port" = 1099, "protocol" = "tcp" }
    # WinRM
    winrm-http-tcp  = { "to_port" = 5985, "from_port" = 5985, "protocol" = "tcp" }
    winrm-https-tcp = { "to_port" = 5986, "from_port" = 5986, "protocol" = "tcp" }
    # Zipkin
    zipkin-admin-tcp       = { "to_port" = 9990, "from_port" = 9990, "protocol" = "tcp" }
    zipkin-admin-query-tcp = { "to_port" = 9901, "from_port" = 9901, "protocol" = "tcp" }
    zipkin-admin-web-tcp   = { "to_port" = 9991, "from_port" = 9991, "protocol" = "tcp" }
    zipkin-query-tcp       = { "to_port" = 9411, "from_port" = 9411, "protocol" = "tcp" }
    zipkin-web-tcp         = { "to_port" = 8080, "from_port" = 8080, "protocol" = "tcp" }
    # Zookeeper
    zookeeper-2181-tcp     = { "to_port" = 2181, "from_port" = 2181, "protocol" = "tcp" }
    zookeeper-2182-tls-tcp = { "to_port" = 2182, "from_port" = 2182, "protocol" = "tcp" }
    zookeeper-2888-tcp     = { "to_port" = 2888, "from_port" = 2888, "protocol" = "tcp" }
    zookeeper-3888-tcp     = { "to_port" = 3888, "from_port" = 3888, "protocol" = "tcp" }
    zookeeper-jmx-tcp      = { "to_port" = 7199, "from_port" = 7199, "protocol" = "tcp" }
    # Open all ports & protocols
    all-all       = { "to_port" = 0, "from_port" = 0, "protocol" = "all" }
    all-tcp       = { "to_port" = 0, "from_port" = 65535, "protocol" = "tcp" }
    all-udp       = { "to_port" = 0, "from_port" = 65535, "protocol" = "udp" }
    all-icmp      = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp" }
    all-ipv6-icmp = { "to_port" = 0, "from_port" = 0, "protocol" = 58 }
    # Common Ingress
    all-from-self     = { "to_port" = 0, "from_port" = 0, "protocol" = "all", self = true }
    https-from-public = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
    http-from-public  = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
    icmp-from-public  = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
    ping-from-public  = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
    # Common Egress
    all-to-self   = { "to_port" = 0, "from_port" = 0, "protocol" = "all", self = true }
    all-to-public = { "to_port" = 0, "from_port" = 0, "protocol" = "all", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
  }
}
