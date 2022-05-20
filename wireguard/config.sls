{% from "wireguard/map.jinja" import wireguard with context %}

include:
  - wireguard.install

wireguard_enable:
  sysrc.managed:
    - name: wireguard_enable
{% if wireguard.enabled|default(True) %}
    - value: "YES"
{% else %}
    - value: "NO"
{% endif %}

wireguard_conf_dir:
  file.directory:
    - name: {{ wireguard.conf_dir }}
    - user: root
    - group: wheel
    - mode: 750
    - makedirs: True
    - require:
      - pkg: wireguard_pkg

{% for interface, config in wireguard.interfaces.items() %}

wireguard_interface_{{ interface }}:
  ini.options_present:
    - name: {{ wireguard.conf_dir | path_join(interface) ~ '.conf' }}
    - separator: '='
    - sections: {{ config.ini|yaml() }}

{% endfor %}
