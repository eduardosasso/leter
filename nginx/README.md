docker build -t leter-nginx .

docker run -it leter-nginx
docker run -it leter-nginx /bin/bash

docker-compose build
docker-compose up
docker-compose exec nginx sh
