
#docker stop ca-ordererOrg orderer1-ordererOrg orderer2-ordererOrg orderer3-ordererOrg

#docker rm ca-ordererOrg orderer1-ordererOrg orderer2-ordererOrg orderer3-ordererOrg

#rm -rf channel-artifacts
#mkdir channel-artifacts

#rm -rf /tmp/hyperledger/ordererOrg

# start ca server       >> CA 생성 API
docker-compose -f ordererOrg-ca.yaml up -d

sleep 3

# Enrolling ordererOrg's CA Admin       >> associate API
./bin/fabric-ca-client enroll -d -u https://ca-ordererOrg-admin:ca-ordererOrg-adminpw@0.0.0.0:7053 --home /tmp/hyperledger/ordererOrg/ca/admin --mspdir /tmp/hyperledger/ordererOrg/ca/admin --tls.certfiles /tmp/hyperledger/ordererOrg/ca/crypto/ca-cert.pem

./bin/fabric-ca-client affiliation remove --force org1 -u https://0.0.0.0:7053 --home /tmp/hyperledger/ordererOrg/ca/admin --tls.certfiles /tmp/hyperledger/ordererOrg/ca/crypto/ca-cert.pem

./bin/fabric-ca-client affiliation remove --force org2 -u https://0.0.0.0:7053 --home /tmp/hyperledger/ordererOrg/ca/admin --tls.certfiles /tmp/hyperledger/ordererOrg/ca/crypto/ca-cert.pem

./bin/fabric-ca-client affiliation add ordererOrg -u https://0.0.0.0:7053 --home /tmp/hyperledger/ordererOrg/ca/admin --tls.certfiles /tmp/hyperledger/ordererOrg/ca/crypto/ca-cert.pem

./bin/fabric-ca-client getcainfo -u https://0.0.0.0:7053 --home /tmp/hyperledger/ordererOrg/ca/admin --mspdir /tmp/hyperledger/ordererOrg/msp --tls.certfiles /tmp/hyperledger/ordererOrg/ca/crypto/ca-cert.pem
cp /home/ubuntu/ca-demo/configi-ord.yaml /tmp/hyperledger/ordererOrg/msp/config.yaml
mkdir /tmp/hyperledger/ordererOrg/msp/tlscacerts && cp /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem /tmp/hyperledger/ordererOrg/msp/tlscacerts/tls-0-0-0-0-7053.pem

# Enroll OrdererOrg       >> user create API
## Create orderer1 node
### Register orderer1 node
./bin/fabric-ca-client register -d --id.name orderer1-ordererOrg --id.secret ordererOrgpw --id.type orderer --id.affiliation ordererOrg -u https://0.0.0.0:7053 --home /tmp/hyperledger/ordererOrg/ca/admin --mspdir /tmp/hyperledger/ordererOrg/ca/admin --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem

### MSP Enroll orderer1 node
./bin/fabric-ca-client enroll -d -u https://orderer1-ordererOrg:ordererOrgpw@0.0.0.0:7053 --mspdir /tmp/hyperledger/ordererOrg/orderer1/msp --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem
cp  /home/ubuntu/ca-demo/config-ord.yaml  /tmp/hyperledger/ordererOrg/orderer1/msp/config.yaml
cp /tmp/hyperledger/ordererOrg/orderer1/msp/keystore/$(ls /tmp/hyperledger/ordererOrg/orderer1/msp/keystore) /tmp/hyperledger/ordererOrg/orderer1/msp/keystore/key.pem
mkdir /tmp/hyperledger/ordererOrg/orderer1/msp/tlscacerts && cp /tmp/hyperledger/ordererOrg/orderer1/msp/cacerts/0-0-0-0-7053.pem /tmp/hyperledger/ordererOrg/orderer1/msp/tlscacerts/tls-0-0-0-0-7053.pem

### TLS Enroll orderer1 node
./bin/fabric-ca-client enroll -d -u https://orderer1-ordererOrg:ordererOrgpw@0.0.0.0:7053 --enrollment.profile tls --csr.hosts orderer1-ordererOrg --mspdir /tmp/hyperledger/ordererOrg/orderer1/tls-msp --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem
cp /tmp/hyperledger/ordererOrg/orderer1/tls-msp/keystore/$(ls /tmp/hyperledger/ordererOrg/orderer1/tls-msp/keystore) /tmp/hyperledger/ordererOrg/orderer1/tls-msp/keystore/key.pem

## Create orderer2 node
### Register orderer2 node
./bin/fabric-ca-client register -d --id.name orderer2-ordererOrg --id.secret ordererOrgpw --id.type orderer --id.affiliation ordererOrg -u https://0.0.0.0:7053 --home /tmp/hyperledger/ordererOrg/ca/admin --mspdir /tmp/hyperledger/ordererOrg/ca/admin --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem

### MSP Enroll orderer2 node
./bin/fabric-ca-client enroll -d -u https://orderer2-ordererOrg:ordererOrgpw@0.0.0.0:7053 --mspdir /tmp/hyperledger/ordererOrg/orderer2/msp --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem
cp  /home/ubuntu/ca-demo/config-ord.yaml  /tmp/hyperledger/ordererOrg/orderer2/msp/config.yaml
cp /tmp/hyperledger/ordererOrg/orderer2/msp/keystore/$(ls /tmp/hyperledger/ordererOrg/orderer2/msp/keystore) /tmp/hyperledger/ordererOrg/orderer2/msp/keystore/key.pem
mkdir /tmp/hyperledger/ordererOrg/orderer2/msp/tlscacerts && cp /tmp/hyperledger/ordererOrg/orderer2/msp/cacerts/0-0-0-0-7053.pem /tmp/hyperledger/ordererOrg/orderer2/msp/tlscacerts/tls-0-0-0-0-7053.pem

### TLS Enroll orderer2 node
./bin/fabric-ca-client enroll -d -u https://orderer2-ordererOrg:ordererOrgpw@0.0.0.0:7053 --enrollment.profile tls --csr.hosts orderer2-ordererOrg --mspdir /tmp/hyperledger/ordererOrg/orderer2/tls-msp --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem
cp /tmp/hyperledger/ordererOrg/orderer2/tls-msp/keystore/$(ls /tmp/hyperledger/ordererOrg/orderer2/tls-msp/keystore) /tmp/hyperledger/ordererOrg/orderer2/tls-msp/keystore/key.pem


## Create orderer3 node
### Register orderer3 node
./bin/fabric-ca-client register -d --id.name orderer3-ordererOrg --id.secret ordererOrgpw --id.type orderer --id.affiliation ordererOrg -u https://0.0.0.0:7053 --home /tmp/hyperledger/ordererOrg/ca/admin --mspdir /tmp/hyperledger/ordererOrg/ca/admin --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem

## MSP Enroll orderer3 node
./bin/fabric-ca-client enroll -d -u https://orderer3-ordererOrg:ordererOrgpw@0.0.0.0:7053 --mspdir /tmp/hyperledger/ordererOrg/orderer3/msp --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem
cp  /home/ubuntu/ca-demo/config-ord.yaml  /tmp/hyperledger/ordererOrg/orderer3/msp/config.yaml
cp /tmp/hyperledger/ordererOrg/orderer3/msp/keystore/$(ls /tmp/hyperledger/ordererOrg/orderer3/msp/keystore) /tmp/hyperledger/ordererOrg/orderer3/msp/keystore/key.pem
mkdir /tmp/hyperledger/ordererOrg/orderer3/msp/tlscacerts && cp /tmp/hyperledger/ordererOrg/orderer3/msp/cacerts/0-0-0-0-7053.pem /tmp/hyperledger/ordererOrg/orderer3/msp/tlscacerts/tls-0-0-0-0-7053.pem

### TLS Enroll orderer3 node
./bin/fabric-ca-client enroll -d -u https://orderer3-ordererOrg:ordererOrgpw@0.0.0.0:7053 --enrollment.profile tls --csr.hosts orderer3-ordererOrg --mspdir /tmp/hyperledger/ordererOrg/orderer3/tls-msp --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem
cp /tmp/hyperledger/ordererOrg/orderer3/tls-msp/keystore/$(ls /tmp/hyperledger/ordererOrg/orderer3/tls-msp/keystore) /tmp/hyperledger/ordererOrg/orderer3/tls-msp/keystore/key.pem


# Enroll ordererOrg's Admin
## Register orderer-admin
./bin/fabric-ca-client register -d --id.name admin-ordererOrg --id.secret ordererOrgadminpw --id.type admin --id.affiliation ordererOrg --id.attrs "hf.Registrar.Roles=*,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7053 --home /tmp/hyperledger/ordererOrg/ca/admin --mspdir /tmp/hyperledger/ordererOrg/ca/admin --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem

## MSP Enroll ordererOrg-admin
./bin/fabric-ca-client enroll -d -u https://admin-ordererOrg:ordererOrgadminpw@0.0.0.0:7053 --mspdir /tmp/hyperledger/ordererOrg/admin/msp --tls.certfiles /tmp/hyperledger/ordererOrg/msp/cacerts/0-0-0-0-7053.pem
cp  /home/ubuntu/ca-demo/config-ord.yaml  /tmp/hyperledger/ordererOrg/admin/msp/config.yaml
mkdir /tmp/hyperledger/ordererOrg/admin/msp/tlscacerts && cp /tmp/hyperledger/ordererOrg/admin/msp/cacerts/0-0-0-0-7053.pem /tmp/hyperledger/ordererOrg/admin/msp/tlscacerts/tls-0-0-0-0-7053.pem

# Setiing admincerts for all msp folders
mkdir -p /tmp/hyperledger/ordererOrg/msp/admincerts
mkdir -p /tmp/hyperledger/ordererOrg/admin/msp/admincerts
mkdir -p /tmp/hyperledger/ordererOrg/orderer1/msp/admincerts
mkdir -p /tmp/hyperledger/ordererOrg/orderer2/msp/admincerts
mkdir -p /tmp/hyperledger/ordererOrg/orderer3/msp/admincerts
cp /tmp/hyperledger/ordererOrg/admin/msp/signcerts/cert.pem /tmp/hyperledger/ordererOrg/msp/admincerts/orderer-admin-cert.pem
cp /tmp/hyperledger/ordererOrg/admin/msp/signcerts/cert.pem /tmp/hyperledger/ordererOrg/admin/msp/admincerts/orderer-admin-cert.pem
cp /tmp/hyperledger/ordererOrg/admin/msp/signcerts/cert.pem /tmp/hyperledger/ordererOrg/orderer1/msp/admincerts/orderer-admin-cert.pem
cp /tmp/hyperledger/ordererOrg/admin/msp/signcerts/cert.pem /tmp/hyperledger/ordererOrg/orderer2/msp/admincerts/orderer-admin-cert.pem
cp /tmp/hyperledger/ordererOrg/admin/msp/signcerts/cert.pem /tmp/hyperledger/ordererOrg/orderer3/msp/admincerts/orderer-admin-cert.pem


# setting tls folder from tls-msp
mkdir -p /tmp/hyperledger/ordererOrg/orderer1/tls
mkdir -p /tmp/hyperledger/ordererOrg/orderer2/tls
mkdir -p /tmp/hyperledger/ordererOrg/orderer3/tls
cp /tmp/hyperledger/ordererOrg/orderer1/tls-msp/tlscacerts/tls-0-0-0-0-7053.pem /tmp/hyperledger/ordererOrg/orderer1/tls/ca.crt
cp /tmp/hyperledger/ordererOrg/orderer1/tls-msp/signcerts/cert.pem /tmp/hyperledger/ordererOrg/orderer1/tls/server.crt
cp /tmp/hyperledger/ordererOrg/orderer1/tls-msp/keystore/key.pem /tmp/hyperledger/ordererOrg/orderer1/tls/server.key

cp /tmp/hyperledger/ordererOrg/orderer2/tls-msp/tlscacerts/tls-0-0-0-0-7053.pem /tmp/hyperledger/ordererOrg/orderer2/tls/ca.crt
cp /tmp/hyperledger/ordererOrg/orderer2/tls-msp/signcerts/cert.pem /tmp/hyperledger/ordererOrg/orderer2/tls/server.crt
cp /tmp/hyperledger/ordererOrg/orderer2/tls-msp/keystore/key.pem /tmp/hyperledger/ordererOrg/orderer2/tls/server.key

cp /tmp/hyperledger/ordererOrg/orderer3/tls-msp/tlscacerts/tls-0-0-0-0-7053.pem /tmp/hyperledger/ordererOrg/orderer3/tls/ca.crt
cp /tmp/hyperledger/ordererOrg/orderer3/tls-msp/signcerts/cert.pem /tmp/hyperledger/ordererOrg/orderer3/tls/server.crt
cp /tmp/hyperledger/ordererOrg/orderer3/tls-msp/keystore/key.pem /tmp/hyperledger/ordererOrg/orderer3/tls/server.key


# Create Genesis.Block
./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block -channelID syschannel
./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID mychannel
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP



docker-compose -f orderer.yaml up -d
