{% from "wireguard/map.jinja" import wireguard with context %}

wireguard_pkg:
  pkg.installed:
    - name: {{ wireguard.pkg }}
