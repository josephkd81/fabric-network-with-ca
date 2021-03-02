#docker stop ca-org2 peer1-org2 peer2-org2
#docker rm ca-org2 peer1-org2 peer2-org2

#rm -rf /tmp/hyperledger/org2

# Start Org1's CA Server
docker-compose -f org2-ca.yaml up -d

sleep 3

# Enrolling Org1's CA Admin
./bin/fabric-ca-client enroll -d -u https://ca-org2-admin:ca-org2-adminpw@0.0.0.0:7055 --home /tmp/hyperledger/org2/ca/admin --mspdir /tmp/hyperledger/org2/ca/admin --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem

./bin/fabric-ca-client affiliation remove --force org1 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org2/ca/admin --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem

./bin/fabric-ca-client affiliation remove --force org2 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org2/ca/admin --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem

./bin/fabric-ca-client affiliation add org1 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org2/ca/admin --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem

# Set ca's msp folder for configtx.yaml
./bin/fabric-ca-client getcainfo -u https://0.0.0.0:7055 --home /tmp/hyperledger/org2/ca/admin --mspdir /tmp/hyperledger/org2/msp --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem

cp /home/ubuntu/ca-demo/config-pr2.yaml /tmp/hyperledger/org2/msp/config.yaml

# Enroll Peer1
./bin/fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1PW --id.type peer --id.affiliation org2 -u https://0.0.0.0:7055 --home /tmp/hyperledger/org2/ca/admin --mspdir /tmp/hyperledger/org2/ca/admin --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7055 --mspdir /tmp/hyperledger/org2/peer1/msp --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7055 --enrollment.profile tls --csr.hosts peer1-org2 --mspdir /tmp/hyperledger/org2/peer1/tls-msp --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
cp /tmp/hyperledger/org2/peer1/tls-msp/keystore/$(ls /tmp/hyperledger/org2/peer1/tls-msp/keystore) /tmp/hyperledger/org2/peer1/tls-msp/keystore/key.pem
cp /home/ubuntu/ca-demo/config-pr2.yaml /tmp/hyperledger/org2/peer1/msp/config.yaml

# Enroll Peer2
./bin/fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer --id.affiliation org2 -u https://0.0.0.0:7055 --home /tmp/hyperledger/org2/ca/admin --mspdir /tmp/hyperledger/org2/ca/admin --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://peer2-org2:peer2PW@0.0.0.0:7055 --mspdir /tmp/hyperledger/org2/peer2/msp --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://peer2-org2:peer2PW@0.0.0.0:7055 --enrollment.profile tls --csr.hosts peer2-org2 --mspdir /tmp/hyperledger/org2/peer2/tls-msp --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
cp /tmp/hyperledger/org2/peer2/tls-msp/keystore/$(ls /tmp/hyperledger/org2/peer2/tls-msp/keystore) /tmp/hyperledger/org2/peer2/tls-msp/keystore/key.pem
cp /home/ubuntu/ca-demo/config-pr2.yaml /tmp/hyperledger/org2/peer2/msp/config.yaml

# Enroll Org1's Admin
./bin/fabric-ca-client register -d --id.name admin-org2 --id.secret org2AdminPW --id.type admin --id.affiliation org2 -u https://0.0.0.0:7055 --home /tmp/hyperledger/org2/ca/admin --mspdir /tmp/hyperledger/org2/ca/admin --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://admin-org2:org2AdminPW@0.0.0.0:7055 --mspdir /tmp/hyperledger/org2/admin/msp --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
cp /home/ubuntu/ca-demo/config-pr2.yaml /tmp/hyperledger/org2/admin/msp/config.yaml

mkdir /tmp/hyperledger/org2/peer1/msp/admincerts
mkdir /tmp/hyperledger/org2/peer2/msp/admincerts
cp /tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /tmp/hyperledger/org2/peer1/msp/admincerts/org2-admin-cert.pem
cp /tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /tmp/hyperledger/org2/peer2/msp/admincerts/org2-admin-cert.pem

# Enroll Org1's User
./bin/fabric-ca-client register -d --id.name user-org2 --id.secret org2UserPW --id.type client --id.affiliation org2 -u https://0.0.0.0:7055 --home /tmp/hyperledger/org2/ca/admin --mspdir /tmp/hyperledger/org2/ca/admin --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://user-org2:org2UserPW@0.0.0.0:7055 --mspdir /tmp/hyperledger/org2/user/msp --tls.certfiles /tmp/hyperledger/org2/ca/crypto/ca-cert.pem
cp /home/ubuntu/ca-demo/config-pr1.yaml /tmp/hyperledger/org2/user/msp/config.yaml

# Start Peer Containers
docker-compose -f peer-org2.yaml up -d
