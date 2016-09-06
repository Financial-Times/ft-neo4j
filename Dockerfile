FROM alpine:3.4

RUN apk update && apk add openjdk8-jre curl bash

ENV NEO4J_SHA256 7b2f30d73af107eacd9a3a619475ef448a08eecb2cdb42ab1f8a38d091c70ecb
ENV NEO4J_TARBALL neo4j-community-2.3.1-unix.tar.gz
ARG NEO4J_URI=http://dist.neo4j.org/neo4j-community-2.3.1-unix.tar.gz

COPY ./local-package/* /tmp/

RUN curl --fail --silent --show-error --location --remote-name ${NEO4J_URI} \
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
