#/bin/bash

if [ x${ELASTIC_PASSWORD} == x ]; then
  echo "Set the ELASTIC_PASSWORD environment variable in the .env file"
  exit 1
elif [ x${KIBANA_PASSWORD} == x ]; then
  echo "Set the KIBANA_PASSWORD environment variable in the .env file"
  exit 1
fi

echo "Waiting for Elasticsearch availability"
until
  curl -sI -u elastic:${ELASTIC_PASSWORD} http://es:9200 | grep -q "200 OK"
do
  sleep 30
done

echo "Setting kibana_system password"
until
  curl -s -X POST -u elastic:${ELASTIC_PASSWORD} -H "Content-Type: application/json" http://es:9200/_security/user/kibana_system/_password -d "{\"password\":\"${KIBANA_PASSWORD}\"}" | grep -q "^{}"
do
  sleep 10
done

echo "All done!"
