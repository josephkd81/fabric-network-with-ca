docker stop $(docker ps -q)
docker rm $(docker ps -aq)

rm -rf /tmp/hyperledger

rm -rf channel-artifacts

mkdir channel-artifacts

docker volume prune -f

docker network prune -f

./cmd-peer-org1-cliOnly.sh

sleep 3

./cmd-peer-org2-cliOnly.sh

sleep 3

./cmd-orderer-cliOnly.sh

sleep 3

#docker-compose -f cli.yaml up -d

docker exec cli peer channel create -o orderer1-ordererOrg:7050 -c mychannel -f ./channel-artifacts/mychannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/crypto-config/ordererOrg/msp/tlscacerts/tls-0-0-0-0-7053.pem

docker exec cli peer channel update -o orderer1-ordererOrg:7050 -c mychannel -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/crypto-config/ordererOrg/msp/tlscacerts/tls-0-0-0-0-7053.pem

docker exec cli peer channel fetch 0 ./channel-artifacts/mychannel.block -c mychannel -o orderer1-ordererOrg:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/crypto-config/ordererOrg/msp/tlscacerts/tls-0-0-0-0-7053.pem

docker exec cli peer channel join -b ./channel-artifacts/mychannel.block

docker exec cli peer chaincode install -n mycc -v "1.0" -p github.com/hyperledger/fabric/chaincode/exam

docker exec cli peer chaincode instantiate -o orderer1-ordererOrg:7050 -C mychannel -n mycc -v "1.0" -c '{"Args":["init","a","100","b","200"]}' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/crypto-config/ordererOrg/msp/tlscacerts/tls-0-0-0-0-7053.pem

sleep 10

docker exec cli peer chaincode invoke -o orderer1-ordererOrg:7050 -C mychannel -n mycc -c '{"Args":["invoke","a","b","10"]}' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/crypto-config/ordererOrg/msp/tlscacerts/tls-0-0-0-0-7053.pem

sleep 3

docker exec cli peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'
