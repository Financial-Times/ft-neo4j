FROM alpine:3.4

ENV NEO4J_VERSION=2.3.7
ENV NEO4J_SHA256=660f69e2dce24b69c6abe25fd33b549c8e232b965bef4ca94acb9f63cc15e46e
ENV NEO4J_TARBALL=neo4j-community-${NEO4J_VERSION}-unix.tar.gz
ARG NEO4J_URI=https://neo4j.com/artifact.php?name=neo4j-community-${NEO4J_VERSION}-unix.tar.gz

COPY ./local-package/* /tmp/

RUN apk update && apk add --no-cache openjdk8-jre curl bash ca-certificates

RUN curl --fail --show-error --silent --location ${NEO4J_URI} -o ${NEO4J_TARBALL} \
    && echo "${NEO4J_SHA256}  ${NEO4J_TARBALL}" >/tmp/cs \
    && sha256sum -c /tmp/cs \
    && rm /tmp/cs \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* /var/lib/neo4j \
    && rm ${NEO4J_TARBALL}

WORKDIR /var/lib/neo4j

RUN mv data /data \
    && ln -s /data /var/lib/neo4j/

VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY neo4j-http-logging.xml /neo4j-http-logging.xml

EXPOSE 7474 7473

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]
