sudo bash -c 'echo 129 > /proc/sys/net/ipv4/ip_default_ttl'
echo "net.ipv4.ip_default_ttl=129" >> /etc/sysctl.conf