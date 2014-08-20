{%- if grains['os_family'] == 'Debian' %}
logstash-forwarder-key:
  cmd.run:
    - name: wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
    - unless: apt-key list | grep 'Elasticsearch (Elasticsearch Signing Key)'

logstash-forwarder-repo:
  pkgrepo.managed:
    - humanname: Logstash Forwarder Debian Repository
    - name: deb http://packages.elasticsearch.org/logstashforwarder/debian stable main
    - require:
      - cmd: logstash-forwarder-key
{%- elif grains['os_family'] == 'RedHat' %}
logstash-key:
  cmd.run:
    - name: rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - unless: rpm -qi gpg-pubkey-d88e42b4-52371eca
  
  logstash-repo:
    pkgrepo.managed:
      - humanname: logstash-forwarder repository for 1.4.x packages
      - baseurl: http://packages.elasticsearch.org/logstashforwarder/centos/
      - gpgcheck: 1
      - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
      - enabled: 1
      - require:
        - cmd: logstash-forwarder-key
 {%- endif %}