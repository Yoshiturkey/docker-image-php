TMP_IMAGE_NAME=tmp_$(shell date +%Y%m%d%H%M%S)
REPOSITORY=asia.gcr.io/staydaybreak-1470451989658/php
RUN_NAME=build_after_tester
build:
	@docker pull php:7.3-fpm-alpine
	@docker build -t ${TMP_IMAGE_NAME} .
	@docker tag ${TMP_IMAGE_NAME} ${REPOSITORY}
	@docker rmi ${TMP_IMAGE_NAME}
test:
	@docker run --name ${RUN_NAME} -itd ${REPOSITORY}
stop:
	@docker stop ${RUN_NAME} && docker rm ${RUN_NAME}
push:
	@docker push ${REPOSITORY}
