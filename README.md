## Development
brew services start mysql (running on port 3307)
docker-compose build
docker-compose up
docker-compose exec admin rails c
docker-compose exec admin bash
http://localhost:3000/rails/info/routes - list all routes

rails generate devise:install
