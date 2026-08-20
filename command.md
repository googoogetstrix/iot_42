## Check port is available
```
ss -tulpn
```

## Check all services
```
service --status-all
```

## Check linux version
```
cat /etc/os-release
```

## Shutdown
```
sudo shutdown --halt
```

## Check time of machine
```
datetimectl
date
```

## Install virtualbox guest utility
```
sudo apt-get update
sudo apt-get install build-essential dkms linux-headers-$(uname -r) virtualbox-guest-utils
sudo reboot
sudo adduser $USER vboxsf
sudo reboot
```
