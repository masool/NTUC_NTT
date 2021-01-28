#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer0.tradeunion.ntuc.com/tls/ca.crt
export PEER1_ORG1_CA=${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/peers/peer1.tradeunion.ntuc.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer0.tradeassociation.ntuc.com/tls/ca.crt
export PEER1_ORG2_CA=${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/peers/peer1.tradeassociation.ntuc.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer0.socialenterprise.ntuc.com/tls/ca.crt
export PEER1_ORG3_CA=${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/peers/peer1.socialenterprise.ntuc.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/ntuc.com/orderers/orderer.ntuc.com/msp/tlscacerts/tlsca.ntuc.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/ntuc.com/users/Admin@ntuc.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  # local USING_ORG=""
  # if [ -z "$OVERRIDE_ORG" ]; then
    PEER=$1
    USING_ORG=$2
  # else
  #   USING_ORG="${OVERRIDE_ORG}"
  #   PEER="${OVERRIDE_ORG}"
  # fi
  echo "Using Peer ${PEER}"
  echo "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/tradeunion.ntuc.com/users/Admin@tradeunion.ntuc.com/msp
  if [ $PEER -eq 0 ]; then
    export CORE_PEER_ADDRESS=localhost:7051
    else
    export CORE_PEER_ADDRESS=localhost:8051
    fi
    # export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/tradeassociation.ntuc.com/users/Admin@tradeassociation.ntuc.com/msp
    # export CORE_PEER_ADDRESS=localhost:9051
        if [ $PEER -eq 0 ]; then
    export CORE_PEER_ADDRESS=localhost:9051
    else
    export CORE_PEER_ADDRESS=localhost:10051
    fi
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/socialenterprise.ntuc.com/users/Admin@socialenterprise.ntuc.com/msp
    # export CORE_PEER_ADDRESS=localhost:11051
         if [ $PEER -eq 0 ]; then
    export CORE_PEER_ADDRESS=localhost:11051
    else
    export CORE_PEER_ADDRESS=localhost:12051
    fi
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
# parsePeerConnectionParameters() {
#   if [ $(($# % 2)) -ne 0 ]; then
#     exit 1
#   fi
#   PEER_CONN_PARMS=""
#   PEERS=""
#   while [ "$#" -gt 0 ]; do
#     setGlobals $1 $2
#     PEER="peer$1.$2"
#     ## Set peer adresses
#     PEERS="$PEERS $PEER"
#     export PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
#     ## Set path to TLS certificate
#     TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER$1_ORG$2_CA")
#     PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
#     # shift by one to get to the next organization
#     shift
#   done
#   # remove leading space for output
#   PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
# }
parsePeerConnectionParameters() {
  # check for uneven number of peer and org parameters
  if [ $(($# % 2)) -ne 0 ]; then
    exit 1
  fi

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1 $2
    PEER="peer$1.org$2"
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "true" ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER$1_ORG$2_CA")
      PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    fi
    # shift by two to get the next pair of peer/org parameters
    shift
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}
verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}
