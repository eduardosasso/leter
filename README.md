# Leter.co

export DO_API_KEY="7f5365f5842c356f30513657f35c5819d52be77d6d0abeb702066a113be50bc9"
curl https://get.acme.sh | sh
acme.sh --issue -d leter.co  -d '*.leter.co' --dns dns_dgon -w /root/leter/public
