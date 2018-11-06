## Development
brew services start mysql (running on port 3307)
docker-compose build
docker-compose up
docker-compose exec admin rails c
docker-compose exec admin bash
docker-compose exec nginx bash
http://localhost:3000/rails/info/routes - list all routes
reload nginx config inside container /etc/init.d/nginx reload
