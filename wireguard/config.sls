{% from "wireguard/map.jinja" import wireguard with context %}

include:
  - wireguard.install

wireguard_conf_dir:
  file.directory:
    - name: {{ wireguard.conf_dir }}
    - user: root
    - group: wheel
    - mode: 750
    - makedirs: True
