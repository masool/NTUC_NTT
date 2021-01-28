#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

ORG=tradeunion
P0PORT=7051
P1PORT=8051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/tradeunion.ntuc.com/tlsca/tlsca.tradeunion.ntuc.com-cert.pem
CAPEM=organizations/peerOrganizations/tradeunion.ntuc.com/ca/ca.tradeunion.ntuc.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/tradeunion.ntuc.com/connection-tradeunion.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/tradeunion.ntuc.com/connection-tradeunion.yaml

ORG=tradeassociation
P0PORT=9051
P1PORT=10051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/tradeassociation.ntuc.com/tlsca/tlsca.tradeassociation.ntuc.com-cert.pem
CAPEM=organizations/peerOrganizations/tradeassociation.ntuc.com/ca/ca.tradeassociation.ntuc.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/tradeassociation.ntuc.com/connection-tradeassociation.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/tradeassociation.ntuc.com/connection-tradeassociation.yaml

ORG=socialenterprise
P0PORT=11051
P1PORT=12051
CAPORT=9054
PEERPEM=organizations/peerOrganizations/socialenterprise.ntuc.com/tlsca/tlsca.socialenterprise.ntuc.com-cert.pem
CAPEM=organizations/peerOrganizations/socialenterprise.ntuc.com/ca/ca.socialenterprise.ntuc.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/socialenterprise.ntuc.com/connection-socialenterprise.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/socialenterprise.ntuc.com/connection-socialenterprise.yaml