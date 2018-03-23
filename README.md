# Leter.co

curl https://get.acme.sh | sh

export DO_API_KEY=

acme.sh --issue --dns dns_dgon -d leter.co -d *.leter.co


acme.sh --install-cert -d leter.co -d *.leter.co \
--key-file ~/leter/ssl/key.pem \
--fullchain-file ~/leter/ssl/cert.pem \
--reloadcmd "cd ~/leter/ && docker-compose exec nginx bash /etc/init.d/nginx reload"

