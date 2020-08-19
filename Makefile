DVC_IMAGE=dvc-image
APP_IMAGE=cts-pf-pcv-rest

build-dvc:
	docker build --no-cache -t $(DVC_IMAGE) -f cts_doc_von_count/Dockerfile cts_doc_von_count

pull-version:
	make build-dvc
	docker run --rm -v $(PWD):/data -w /data $(DVC_IMAGE) -u $(GIT_USER) -p $(GIT_PASS) -e cts-core-team@coupa.com --files pom.xml

push-version:
	make build-dvc
	docker run --rm -v $(PWD):/data -w /data $(DVC_IMAGE) -u $(GIT_USER) -p $(GIT_PASS) -e cts-core-team@coupa.com --push --upgrade

build:
	make build-dvc
	docker build --no-cache --build-arg JFROG_USER=${JFROG_USER} --build-arg JFROG_PASS=${JFROG_PASS} \
		--build-arg GIT_USER=${GIT_USER} --build-arg GIT_PASS=${GIT_PASS} -t $(APP_IMAGE) .

test:
	docker run --rm $(APP_IMAGE) test -s .mvn/settings.xml

deploy:
	docker run --rm $(APP_IMAGE) deploy -Dmaven.test.skip=true -DJFROG_USER=${JFROG_USER} -DJFROG_PASS=${JFROG_PASS} -s .mvn/settings.xml
