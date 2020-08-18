FROM dvc-image as versioning

ARG GIT_USER
ARG GIT_PASS
ARG GIT_EMAIL='cts-core-team@coupa.com'
ENV GIT_USER=$GIT_USER
ENV GIT_PASS=$GIT_PASS
ENV GIT_EMAIL=$GIT_EMAIL

COPY .git/ .git/
COPY pom.xml .
RUN ./version.sh -u ${GIT_USER} -p ${GIT_PASS} -e ${GIT_EMAIL} --files pom.xml


FROM maven:3-alpine

# Set up settings.xml for yapta repos
ARG JFROG_USER
ARG JFROG_PASS
ENV JFROG_USER=$JFROG_USER
ENV JFROG_PASS=$JFROG_PASS

COPY .mvn ./.mvn
COPY src ./src
COPY --from=versioning /pom.xml .

RUN mvn compile -s .mvn/settings.xml && rm -rf target

ENTRYPOINT ["mvn"]