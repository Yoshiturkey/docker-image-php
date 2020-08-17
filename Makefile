TMP_IMAGE_NAME=tmp_$(shell date +%Y%m%d%H%M%S)
REPOSITORY=asia.gcr.io/staydaybreak-1470451989658/php
RUN_NAME=php7-tester

build:
	@docker build -t ${TMP_IMAGE_NAME} . --no-cache=true --force-rm=true --pull=true
	@docker tag ${TMP_IMAGE_NAME} ${REPOSITORY}
	@docker rmi ${TMP_IMAGE_NAME}
test:
	@docker run -p 9000:9000 --name ${RUN_NAME} -itd ${REPOSITORY}
compose:
	@docker-compose up -d
compose-down:
	@docker-compose down
stop:
	@docker stop ${RUN_NAME} && docker rm ${RUN_NAME}
push:
	@docker push ${REPOSITORY}
