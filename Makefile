test:
	docker-compose exec nginx ruby nginx_test.rb
	docker-compose exec rails rails test
build:
	docker-compose build
run:
	docker-compose up
