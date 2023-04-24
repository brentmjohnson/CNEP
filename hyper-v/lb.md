apk add nginx-mod-stream
ls -l /usr/lib/nginx/modules/

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -addext "subjectAltName = IP:10.0.0.2" -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
Country Name (2 letter code) [AU]:.
State or Province Name (full name) [Some-State]:.
Locality Name (eg, city) []:.
Organization Name (eg, company) [Internet Widgits Pty Ltd]:.
Organizational Unit Name (eg, section) []:.
Common Name (e.g. server FQDN or YOUR name) []:10.0.0.2
Email Address []:.

openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

scp ./hyper-v/nginx.conf root@10.0.0.2:/etc/nginx/nginx.conf
rc-status
rc-service nginx restart
rc-status

scp root@10.0.0.2:/etc/nginx/nginx.conf ./hyper-v/nginx.conf 