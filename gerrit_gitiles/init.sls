{%- from "gerrit_gitiles/map.jinja" import gerrit_gitiles, sls_block with context -%}
{%- from 'gerrit/map.jinja' import settings, directory with context -%}

gerrit_gitiles_plugin:
  file.managed:
    - name: {{ directory }}/plugins/gitiles.jar
    - user: {{ settings.user }}
    - group: {{ settings.group }}
    {{ sls_block(gerrit_gitiles.plugin) }}
    - watch_in:
      - service: gerrit_service

gerrit_gitiles_config:
  file.managed:
    - name: {{ directory }}/etc/gitiles.config
    - source: salt://gerrit_gitiles/files/gitiles.config
    - template: jinja
    - user: {{ settings.user }}
    - group: {{ settings.group }}
    - makedirs: true
    - defaults:
        sections: {{ gerrit_gitiles.config | yaml() }}
    - watch_in:
      - service: gerrit_service
