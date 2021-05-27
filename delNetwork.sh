docker stop $(docker ps -q)
docker rm $(docker ps -aq)

rm -rf /tmp/hyperledger

rm -rf channel-artifacts

mkdir channel-artifacts

docker volume prune -f

docker network prune -f

