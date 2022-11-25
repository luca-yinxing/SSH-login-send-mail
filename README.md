# SSH-login-send-mail

Just a simple script to notify by email of some login on the ssh server.

### How install
The dependencies are `geoiplookup, s-nail, systemd, pam` so make sure you have those.

If you are on Debian:
`
apt install geoip-bin geoip-database s-nail
`

Download the script and place it on `/opt/ssh-login-send-mail.sh` then configure it with your SMTP parameters then

`
chown root:root /opt/ssh-login-send-mail.sh && chmod 700 /opt/ssh-login-send-mail.sh
`

Then edit the pam configuration at `/etc/pam.d/sshd` adding the following row in `@include common-session`

`session    optional     pam_exec.so seteuid /opt/ssh-login-send-mail.sh`
