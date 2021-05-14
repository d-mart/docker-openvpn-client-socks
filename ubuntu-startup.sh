#!/bin/bash

/usr/sbin/sshd &
openvpn --script-security 2 --config /ovpn.conf
