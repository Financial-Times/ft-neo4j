FROM neo4j:2.3.1

ADD neo4j-server.properties /var/lib/neo4j/conf
ADD neo4j.properties /var/lib/neo4j/conf

CMD ["neo4j"]
