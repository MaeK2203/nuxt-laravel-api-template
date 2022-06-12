init:
	mkcert --install
	mkcert -key-file docker/nginx/ssl/cert-key.pem -cert-file docker/nginx/ssl/cert.pem localhost 127.0.0.1 ::1
	@make destroy
	@make build
	docker-compose exec app cp .env.example .env
	docker-compose exec app php artisan key:generate
	@make wait-for-mysql
	sleep 30
	docker-compose exec app php artisan migrate:fresh --seed
	docker-compose ps
restart:
	docker-compose down
	docker-compose up -d
build:
	docker-compose down
	docker-compose up -d --build
	docker-compose exec app composer install
migration:
	docker-compose exec app php artisan migrate
destroy:
	docker-compose down --rmi all --volumes
	rm -rf docker/db/my.cnf
	rm -rf docker/db/data
wait-for-mysql:
	until (docker-compose exec db mysqladmin ping &>/dev/null) do echo 'waiting for mysql wake up...' && sleep 3; done
