# Do nothing unless the target is RedHat or Debian based
{%- if grains['os_family'] == 'RedHat' or grains['os_family'] == 'Debian' %}
{%- from 'logstash_forwarder/map.jinja' import logstash_forwarder with context %}

# Do nothing unless the target is RedHat or Debian based

{%- if grains['os_family'] == 'RedHat' or grains['os_family'] == 'Debian' %}
include:
  - .repo

logstash-forwarder-pkg:
  pkg.latest:
    - name: {{logstash_forwarder.pkg}}
    - require:
      - pkgrepo: logstash-forwarder-repo

{%- if logstash_forwarder.cert_contents is defined %}
logstash-forwarder-cert:
  file.managed:
    - name: {{logstash_forwarder.cert_path}}
    - contents_pillar: logstash_forwarder:cert_contents
    - user: root
    - group: root
    - mode: 664
    - template: jinja
    - watch_in:
      - service: logstash-forwarder-svc
{%- endif %}

logstash-forwarder-config:
  file.managed:
    - name: /etc/logstash-forwarder
    - user: root
    - group: root
    - mode: 644
    - source: salt://logstash_forwarder/files/logstash-forwarder
    - template: jinja
    - watch_in:
      - service: logstash-forwarder-svc

logstash-forwarder-svc:
  service:
    - name: {{logstash_forwarder.svc}}
    - running
    - enable: true
    - require:
      - pkg: logstash-forwarder-pkg
      {%- if logstash_forwarder.cert_contents is defined %}
      - file: logstash-forwarder-cert
      {%- endif %}

logstash-forwarder-init:
  file.managed:
    - name: /etc/init.d/{{logstash_forwarder.svc}}
    - user: root
    - group: root
    - mode: 755
    - source: {{ logstash_forwarder.init_file }}
    - template: jinja
    - watch_in:
      - service: logstash-forwarder-svc
    - require:
      - pkg: logstash-forwarder-pkg
<<<<<<< HEAD
{%- endif %}
=======
{%- endif %}
>>>>>>> cddf066408160e5a7f784c865bb58f1d74846580
