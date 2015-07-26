#!/bin/sh

if [ ! -d "/var/log/vpnserver/security_log" ]; then
  mkdir -p /var/log/vpnserver/security_log
fi

if [ ! -d "/var/log/vpnserver/packet_log" ]; then
  mkdir -p /var/log/vpnserver/packet_log
fi

if [ ! -d "/var/log/vpnserver/server_log" ]; then
  mkdir -p /var/log/vpnserver/server_log
fi

ln -s /var/log/vpnserver/*_log /usr/local/vpnserver/

# We need to start the VPN server, so we can set the config, then restart it..
/usr/local/vpnserver/vpnserver start && printf "Overwriting configuration after 5 second sleep" && sleep 5 && printf 'Hub DEFAULT\nUserCreate '${VPNUSER}' /GROUP:none /REALNAME:'${VPNUSER}' /NOTE:none\nUserPasswordSet '${VPNUSER}' /PASSWORD:'${VPNPASS}'\nSecureNatEnable\n' >> /usr/local/vpnserver/config.txt && /usr/local/vpnserver/vpncmd 127.0.0.1:443 /HUB:DEFAULT /SERVER /IN:/usr/local/vpnserver/config.txt

/usr/local/vpnserver/vpnserver stop && exec /usr/local/vpnserver/vpnserver execsvc

exit $?
