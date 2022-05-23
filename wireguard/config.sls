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

{% if config.enabled|default(True) %}

wireguard_interface_{{ interface }}_enabled:
  cmd.run:
    - name: sysrc wireguard_interfaces+={{ interface }}
    - cmd: /tmp
    - unless:
      - sysrc -n wireguard_interfaces|egrep -q '(^|[[:space:]]){{ interface }}($|[[:space:]])'

{% else %}

wireguard_interface_{{ interface }}_enabled:
  cmd.run:
    - name: sysrc wireguard_interfaces-={{ interface }}
    - cmd: /tmp
    - onlyif:
      - sysrc -n wireguard_interfaces|egrep -q '(^|[[:space:]]){{ interface }}($|[[:space:]])'

{% endif %}

{% endfor %}
