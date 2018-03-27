# Leter.co

curl https://get.acme.sh | sh

export DO_API_KEY=

acme.sh --issue --dns dns_dgon -d leter.co -d '*.leter.co'


acme.sh --install-cert -d leter.co -d '*.leter.co' -d eduardo-sasso.co \
--key-file ~/Dropbox/leter/ssl/key.pem \
--fullchain-file ~/Dropbox/leter/ssl/cert.pem 

