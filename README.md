# Leter.co

curl https://get.acme.sh | sh

export DO_API_KEY=

acme.sh --issue --dns dns_dgon -d leter.co -d '*.leter.co'

acme.sh --issue --dns dns_dgon -d leter.co -d '*.leter.co' -d 'eduardo-sasso.co' -d 'gismullr.com'

acme.sh --install-cert -d leter.co -d '*.leter.co' -d eduardo-sasso.co -d 'gismullr.com' \
--key-file ~/leter/ssl/key.pem \
--fullchain-file ~/leter/ssl/cert.pem \
--reloadcmd "cd ~/leter/ && docker-compose exec nginx bash /etc/init.d/nginx reload" 


acme.sh --install-cert -d leter.co -d '*.leter.co' -d eduardo-sasso.co -d 'gismullr.com'\
--key-file ~/Dropbox/leter/ssl/key.pem \
--fullchain-file ~/Dropbox/leter/ssl/cert.pem 



for local
npx create-ssl-certificate --hostname leter --domain test


# docker-compose up
# docker-compose exec nginx bash
# docker-compose exec nginx bash /etc/init.d/nginx configtest
# docker-compose exec nginx bash /etc/init.d/nginx reload
# docker-compose exec nginx bash /etc/init.d/nginx configtest
# ssh root@159.65.65.24
