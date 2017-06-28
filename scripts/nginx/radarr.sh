#!/bin/bash
MASTER=$(cat /root/.master.info | cut -d: -f1)
if [[ ! -f /etc/nginx/apps/radarr.conf ]]; then
  cat > /etc/nginx/apps/radarr.conf <<RAD
location /radarr {
  include /etc/nginx/conf.d/proxy.conf;
  proxy_pass        http://127.0.0.1:7878/radarr;
  auth_basic "What's the password?";
  auth_basic_user_file /etc/htpasswd.d/htpasswd.${MASTER};
}
RAD
fi
if [[ ! -d /home/${MASTER}/.config/Radarr/ ]]; then mkdir -p /home/${MASTER}/.config/Radarr/; fi
cat > /home/${MASTER}/.config/Radarr/config.xml <<RAD
<Config>
  <Port>7878</Port>
  <UrlBase>radarr</UrlBase>
  <BindAddress>127.0.0.1</BindAddress>
  <SslPort>9898</SslPort>
  <EnableSsl>False</EnableSsl>
  <LogLevel>Info</LogLevel>
  <Branch>master</Branch>
  <LaunchBrowser>False</LaunchBrowser>
  <UpdateMechanism>BuiltIn</UpdateMechanism>
  <AnalyticsEnabled>False</AnalyticsEnabled>
</Config>
RAD
chown -R ${MASTER}: /home/${MASTER}/.config/Radarr
