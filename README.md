## Blockchain Network V2.0.0

A sample Node.js app to demonstrate **__fabric-client__** & **__fabric-ca-client__** Node.js SDK APIs

### Introduction

* Trinhg to acheive data sharing between fixed entities,  Created three organisations named Tradeunion, Tradeassociation and Social enterprise.

* Register in Tradeunion as a member for this use case, in live production may be millions of members,  register Tradeassociation and social enterprise as organisations.

* Member get a digital voucher with points from tradeassociation and that voucher points can be used to purchase grocerries under social enterprise.

* Using Hpeledgr fabric record every transaction between among three organisations and maintain tracking system.

### Prerequisites and setup:

* [Docker](https://www.docker.com/products/overview) - v1.12 or higher
* [Docker Compose](https://docs.docker.com/compose/overview/) - v1.8 or higher
* [Git client](https://git-scm.com/downloads) - needed for clone commands
* **Node.js** v8.4.0 or higher
* [Download Docker images](http://hyperledger-fabric.readthedocs.io/en/latest/samples.html#binaries)

```
cd fabric-samples/balance-transfer/
```

Once you have completed the above setup, you will have provisioned a local network with the following docker container configuration:

* 3 CAs
* 5 orderers
* 6 peers (2 peers per Org)
* 3 Organisations
* 6 couchdb
* 1 Channel

#### Artifacts
* Crypto material has been generated using the **cryptogen** tool from Hyperledger Fabric and mounted to all peers, the orderering node and CA containers. More details regarding the cryptogen tool are available [here](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html#crypto-generator).
* An Orderer genesis block (genesis.block) and channel configuration transaction (ntuc-channel.tx) has been pre generated using the **configtxgen** tool from Hyperledger Fabric and placed within the artifacts folder. More details regarding the configtxgen tool are available [here](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html#configuration-transaction-generator).

## Running the sample program

There are two options available for running the balance-transfer sample
For each of these options, you may choose to run with chaincode written in golang or in node.js.

##### Terminal Window 1

```
git clone https://github.com/masool/NTUC_NTT.git

cd NTUC_NTT

./startFabric.sh

```

* This launches the required network on your local machine
* Installs the fabric-client and fabric-ca-client node modules

##### Terminal Window 2

## used node.js chaincode

./fabricapi.sh
```
