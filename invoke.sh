#/bin/bash

docker exec cli peer chaincode invoke -o orderer1-ordererOrg:7050 -C mychannel -n mycc -c '{"Args":["invoke","b","a","10"]}' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/crypto-config/ordererOrg/msp/tlscacerts/tls-0-0-0-0-7053.pem

sleep 5

docker exec cli peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'

sleep 5

docker exec cli peer chaincode invoke -o orderer1-ordererOrg:7050 -C mychannel -n mycc -c '{"Args":["invoke","a","b","10"]}' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/crypto-config/ordererOrg/msp/tlscacerts/tls-0-0-0-0-7053.pem

sleep 5

docker exec cli peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'
