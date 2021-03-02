#docker stop ca-org1 peer1-org1 peer2-org1
#docker rm ca-org1 peer1-org1 peer2-org1

#rm -rf /tmp/hyperledger/org1

# Start Org1's CA Server
docker-compose -f org1-ca.yaml up -d

sleep 3

# Enrolling Org1's CA Admin
./bin/fabric-ca-client enroll -d -u https://ca-org1-admin:ca-org1-adminpw@0.0.0.0:7054 --home /tmp/hyperledger/org1/ca/admin --mspdir /tmp/hyperledger/org1/ca/admin --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem

./bin/fabric-ca-client affiliation remove --force org1 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org1/ca/admin --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem

./bin/fabric-ca-client affiliation remove --force org2 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org1/ca/admin --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem

./bin/fabric-ca-client affiliation add org1 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org1/ca/admin --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem

# Set CA msp
./bin/fabric-ca-client getcainfo -u https://0.0.0.0:7054 --home /tmp/hyperledger/org1/ca/admin --mspdir /tmp/hyperledger/org1/msp --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem

cp /home/ubuntu/ca-demo/config-pr1.yaml /tmp/hyperledger/org1/msp/config.yaml

# Enroll Peer1
./bin/fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer --id.affiliation org1 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org1/ca/admin --mspdir /tmp/hyperledger/org1/ca/admin --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://peer1-org1:peer1PW@0.0.0.0:7054 --mspdir /tmp/hyperledger/org1/peer1/msp --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://peer1-org1:peer1PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts peer1-org1 --mspdir /tmp/hyperledger/org1/peer1/tls-msp --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
cp /tmp/hyperledger/org1/peer1/tls-msp/keystore/$(ls /tmp/hyperledger/org1/peer1/tls-msp/keystore) /tmp/hyperledger/org1/peer1/tls-msp/keystore/key.pem
cp /home/ubuntu/ca-demo/config-pr1.yaml /tmp/hyperledger/org1/peer1/msp/config.yaml

# Enroll Peer2
./bin/fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2PW --id.type peer --id.affiliation org1 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org1/ca/admin --mspdir /tmp/hyperledger/org1/ca/admin --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@0.0.0.0:7054 --mspdir /tmp/hyperledger/org1/peer2/msp --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts peer2-org1 --mspdir /tmp/hyperledger/org1/peer2/tls-msp --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
cp /tmp/hyperledger/org1/peer2/tls-msp/keystore/$(ls /tmp/hyperledger/org1/peer2/tls-msp/keystore) /tmp/hyperledger/org1/peer2/tls-msp/keystore/key.pem
cp /home/ubuntu/ca-demo/config-pr1.yaml /tmp/hyperledger/org1/peer2/msp/config.yaml

# Enroll Org1's Admin
./bin/fabric-ca-client register -d --id.name admin-org1 --id.secret org1AdminPW --id.type admin --id.affiliation org1 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org1/ca/admin --mspdir /tmp/hyperledger/org1/ca/admin --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://admin-org1:org1AdminPW@0.0.0.0:7054 --mspdir /tmp/hyperledger/org1/admin/msp --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
cp /home/ubuntu/ca-demo/config-pr1.yaml /tmp/hyperledger/org1/admin/msp/config.yaml

mkdir /tmp/hyperledger/org1/peer1/msp/admincerts
mkdir /tmp/hyperledger/org1/peer2/msp/admincerts
cp /tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/peer1/msp/admincerts/org1-admin-cert.pem
cp /tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/peer2/msp/admincerts/org1-admin-cert.pem

# Enroll Org1's User
./bin/fabric-ca-client register -d --id.name user-org1 --id.secret org1UserPW --id.type client --id.affiliation org1 -u https://0.0.0.0:7054 --home /tmp/hyperledger/org1/ca/admin --mspdir /tmp/hyperledger/org1/ca/admin --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://user-org1:org1UserPW@0.0.0.0:7054 --mspdir /tmp/hyperledger/org1/user/msp --tls.certfiles /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
cp /home/ubuntu/ca-demo/config-pr1.yaml /tmp/hyperledger/org1/user/msp/config.yaml

# Start Peer Containers
docker-compose -f peer-org1.yaml up -d
