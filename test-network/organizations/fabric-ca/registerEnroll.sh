

function createOrg1 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/tradeunion.ntuc.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-tradeunion --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-tradeunion.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-tradeunion.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-tradeunion.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-tradeunion.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-tradeunion --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x
	echo "Register peer1"
  echo
  set -x
    fabric-ca-client register --caname ca-tradeunion --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-tradeunion --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-tradeunion --id.name tradeunionadmin --id.secret tradeunionadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/tradeunion.ntuc.com/peers
  mkdir -p organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com
  mkdir -p organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-tradeunion -M ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/msp --csr.hosts peer0.tradeunion.ntuc.com --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/msp/config.yaml

  echo
  echo "## Generate the peer1 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-tradeunion -M ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/msp --csr.hosts peer1.tradeunion.ntuc.com --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-tradeunion -M ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls --enrollment.profile tls --csr.hosts peer0.tradeunion.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-tradeunion -M ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls --enrollment.profile tls --csr.hosts peer1.tradeunion.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls/server.key

  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/msp/tlscacerts/ca.crt
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/tlsca/tlsca.tradeunion.ntuc.com-cert.pem
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/tlsca/tlsca.tradeunion.ntuc.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/ca
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/ca/ca.tradeunion.ntuc.com-cert.pem
  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/ca/ca.tradeunion.ntuc.com-cert.pem

  mkdir -p organizations/peerOrganizations/tradeunion.ntuc.com/users
  mkdir -p organizations/peerOrganizations/tradeunion.ntuc.com/users/User1@tradeunion.ntuc.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-tradeunion -M ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/users/User1@tradeunion.ntuc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/tradeunion.ntuc.com/users/Admin@tradeunion.ntuc.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://tradeunionadmin:tradeunionadminpw@localhost:7054 --caname ca-tradeunion -M ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/users/Admin@tradeunion.ntuc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/tradeunion/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/users/Admin@tradeunion.ntuc.com/msp/config.yaml

}


function createOrg2 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/tradeassociation.ntuc.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-tradeassociation --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-tradeassociation.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-tradeassociation.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-tradeassociation.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-tradeassociation.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-tradeassociation --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x
	echo "Register peer1"
  echo
  set -x
    fabric-ca-client register --caname ca-tradeassociation --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-tradeassociation --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-tradeassociation --id.name tradeassociationadmin --id.secret tradeassociationadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/tradeassociation.ntuc.com/peers
  mkdir -p organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com
  mkdir -p organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-tradeassociation -M ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/msp --csr.hosts peer0.tradeassociation.ntuc.com --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/msp/config.yaml

  echo
  echo "## Generate the peer1 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-tradeassociation -M ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/msp --csr.hosts peer1.tradeassociation.ntuc.com --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-tradeassociation -M ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls --enrollment.profile tls --csr.hosts peer0.tradeassociation.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-tradeassociation -M ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls --enrollment.profile tls --csr.hosts peer1.tradeassociation.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls/server.key

  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/msp/tlscacerts/ca.crt
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/tlsca/tlsca.tradeassociation.ntuc.com-cert.pem
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/tlsca/tlsca.tradeassociation.ntuc.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/ca
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/ca/ca.tradeassociation.ntuc.com-cert.pem
  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/ca/ca.tradeassociation.ntuc.com-cert.pem

  mkdir -p organizations/peerOrganizations/tradeassociation.ntuc.com/users
  mkdir -p organizations/peerOrganizations/tradeassociation.ntuc.com/users/User1@tradeassociation.ntuc.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-tradeassociation -M ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/users/User1@tradeassociation.ntuc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/tradeassociation.ntuc.com/users/Admin@tradeassociation.ntuc.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://tradeassociationadmin:tradeassociationadminpw@localhost:8054 --caname ca-tradeassociation -M ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/users/Admin@tradeassociation.ntuc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/tradeassociation/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/users/Admin@tradeassociation.ntuc.com/msp/config.yaml

}

function createOrg3 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/socialenterprise.ntuc.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-socialenterprise --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-socialenterprise.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-socialenterprise.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-socialenterprise.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-socialenterprise.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-socialenterprise --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x
	echo "Register peer1"
  echo
  set -x
    fabric-ca-client register --caname ca-socialenterprise --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-socialenterprise --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-socialenterprise --id.name socialenterpriseadmin --id.secret socialenterpriseadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/socialenterprise.ntuc.com/peers
  mkdir -p organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com
  mkdir -p organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-socialenterprise -M ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/msp --csr.hosts peer0.socialenterprise.ntuc.com --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/msp/config.yaml

  echo
  echo "## Generate the peer1 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca-socialenterprise -M ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/msp --csr.hosts peer1.socialenterprise.ntuc.com --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-socialenterprise -M ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls --enrollment.profile tls --csr.hosts peer0.socialenterprise.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca-socialenterprise -M ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls --enrollment.profile tls --csr.hosts peer1.socialenterprise.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls/server.key

  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/msp/tlscacerts/ca.crt
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/tlsca/tlsca.socialenterprise.ntuc.com-cert.pem
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/tlsca/tlsca.socialenterprise.ntuc.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/ca
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/ca/ca.socialenterprise.ntuc.com-cert.pem
  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/ca/ca.socialenterprise.ntuc.com-cert.pem

  mkdir -p organizations/peerOrganizations/socialenterprise.ntuc.com/users
  mkdir -p organizations/peerOrganizations/socialenterprise.ntuc.com/users/User1@socialenterprise.ntuc.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-socialenterprise -M ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/users/User1@socialenterprise.ntuc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/socialenterprise.ntuc.com/users/Admin@socialenterprise.ntuc.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://socialenterpriseadmin:socialenterpriseadminpw@localhost:9054 --caname ca-socialenterprise -M ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/users/Admin@socialenterprise.ntuc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/socialenterprise/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/users/Admin@socialenterprise.ntuc.com/msp/config.yaml

}


function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/ntuc.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/ntuc.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/ntuc.com/orderers
  mkdir -p organizations/ordererOrganizations/ntuc.com/orderers/ntuc.com

  mkdir -p organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com
  mkdir -p organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com
  mkdir -p organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com
  mkdir -p organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com
  mkdir -p organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com

  echo
  echo "## Generate the orderer 1,2,3,4,5 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/msp --csr.hosts orderer.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/msp --csr.hosts orderer2.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/msp --csr.hosts orderer3.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/msp --csr.hosts orderer4.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/msp --csr.hosts orderer5.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/msp/config.yaml
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/msp/config.yaml
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/msp/config.yaml
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/msp/config.yaml
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/msp/config.yaml

  echo
  echo "## Generate the orderer 1,2,3,4,5 -tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/tls --enrollment.profile tls --csr.hosts orderer.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/tls --enrollment.profile tls --csr.hosts orderer2.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/tls --enrollment.profile tls --csr.hosts orderer3.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/tls --enrollment.profile tls --csr.hosts orderer4.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/tls --enrollment.profile tls --csr.hosts orderer5.ntuc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/tls/server.key
  
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/tls/server.key

  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/tls/server.key

  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/tls/server.key

  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/msp/tlscacerts
  mkdir ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/msp/tlscacerts
  mkdir ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/msp/tlscacerts
  mkdir ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/msp/tlscacerts
  mkdir ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer2.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer3.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer4.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer5.ntuc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem

  mkdir -p organizations/ordererOrganizations/ntuc.com/users
  mkdir -p organizations/ordererOrganizations/ntuc.com/users/Admin@ntuc.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ntuc.com/users/Admin@ntuc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/ntuc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ntuc.com/users/Admin@ntuc.com/msp/config.yaml

}