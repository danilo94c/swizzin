#!/bin/bash
MASTER=$(cat /root/.master.info | cut -d: -f1)
if [[ ! -f /etc/nginx/apps/sonarr.conf ]]; then
cat > /etc/nginx/apps/sonarr.conf <<SONARR
location /sonarr {
  include /etc/nginx/conf.d/proxy.conf;
  proxy_pass        http://127.0.0.1:8989/sonarr;
  auth_basic "What's the password?";
  auth_basic_user_file /etc/htpasswd.d/htpasswd.${MASTER};
}
SONARR
fi
if [[ ! -d /home/${MASTER}/.config/NzbDrone/ ]]; then mkdir -p /home/${MASTER}/.config/NzbDrone/; fi
cat > /home/${MASTER}/.config/NzbDrone/config.xml <<SONN
<Config>
  <Port>8989</Port>
  <UrlBase>sonarr</UrlBase>
  <BindAddress>127.0.0.1</BindAddress>
  <SslPort>9898</SslPort>
  <EnableSsl>False</EnableSsl>
  <LogLevel>Info</LogLevel>
  <Branch>master</Branch>
  <LaunchBrowser>False</LaunchBrowser>
</Config>
SONN
chown -R ${MASTER}: /home/${MASTER}/.config/NzbDrone/
