test:
	docker-compose exec nginx ruby nginx_test.rb
	docker-compose exec rails rails test
build:
	docker-compose build
run:
	docker-compose up
nginx:
	docker-compose exec nginx sh
sh:
	docker-compose exec rails bash
railsc:
	docker-compose exec rails rails c

