#!/bin/bash

echo "System information as of $(date)"
echo "  System load:              $(uptime | awk '{print $10}')"
echo "  Usage of /:               $(df -h / | awk 'NR==2 {print $5}')"
echo "  Memory usage:             $(free -m | awk 'NR==2 {print $3/$2 * 100}')%"
echo "  Swap usage:               $(free -m | awk 'NR==4 {print $3/$2 * 100}')%"
echo "  Processes:                $(ps aux | wc -l)"
echo "  Users logged in:          $(who | wc -l)"
echo "  IPv4 address for docker0: $(ip addr show docker0 | grep 'inet' | awk '{print $2}')"
echo "  IPv4 address for enp1s0:  $(ip addr show enp1s0 | grep 'inet' | awk '{print $2}')"
echo "  IPv6 address for enp1s0:  $(ip addr show enp1s0 | grep 'inet6' | awk '{print $2}')"
