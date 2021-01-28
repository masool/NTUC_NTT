/*
 * SPDX-License-Identifier: Apache-2.0
 */
'use strict';

const { Gateway, Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');

/***************************************** CHAINCODES ***********************************************/

/***************************** Create Member ************************************************/
exports.createMember = async function(memberId, accountNumber,firstName,lastName,email,phoneNumber) {
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', '..','..','..', 'test-network', 'organizations', 'peerOrganizations', 'tradeunion.ntuc.com', 'connection-tradeunion.json');
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        var response = {};

        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('TU');
        if (!identity) {
            console.log('An identity for the user "TU" does not exist in the wallet');
            console.log('Run the registerTU.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'TU', discovery: { enabled: true, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('ntuc-channel');

        // Get the contract from the network.
        const contract = network.getContract('ntuc');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')
        // changeCarOwner transaction - requires 2 args , ex: ('changeCarOwner', 'CAR12', 'Dave')
        const result = await contract.submitTransaction('createMember', memberId, accountNumber,firstName,lastName,email,phoneNumber);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);

        // Disconnect from the gateway.
        await gateway.disconnect();
        return result

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response;
        // process.exit(1);
    }
}
/***************************** register trade association ************************************************/

exports.registerTradeAssociation = async function(TAmemberId, name) {
    try {
        const ccpPath = path.resolve(__dirname, '..', '..','..','..', 'test-network', 'organizations', 'peerOrganizations', 'tradeassociation.ntuc.com', 'connection-tradeassociation.json');
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        var response = {};
        const identity = await wallet.get('TA');
        if (!identity) {
            console.log('An identity for the user "TA" does not exist in the wallet');
            console.log('Run the registerTA.js application before retrying');
            return;
        }
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'TA', discovery: { enabled: true, asLocalhost: true } });
        const network = await gateway.getNetwork('ntuc-channel');
        const contract = network.getContract('ntuc');
        const result = await contract.submitTransaction('registerTradeAssociation', TAmemberId, name);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        await gateway.disconnect();
        return result

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response;
    }
}
/***************************** register social enterprise ************************************************/
exports.registerSocialEnterprise = async function(se_memberId, name) {
    try {
        const ccpPath = path.resolve(__dirname, '..', '..','..','..', 'test-network', 'organizations', 'peerOrganizations', 'socialenterprise.ntuc.com', 'connection-socialenterprise.json');
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        var response = {};
        const identity = await wallet.get('SE');
        if (!identity) {
            console.log('An identity for the user "SE" does not exist in the wallet');
            console.log('Run the registerSE.js application before retrying');
            return;
        }
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'SE', discovery: { enabled: true, asLocalhost: true } });
        const network = await gateway.getNetwork('ntuc-channel');
        const contract = network.getContract('ntuc');
        const result = await contract.submitTransaction('registerSocialEnterprise', se_memberId, name);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        await gateway.disconnect();
        return result

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response;
    }
}
/***************************** Create and Issue Digital voucher ************************************************/
exports.IssueDigitalVoucher = async function(TAmemberId,memberId,points) {
    try {
        const ccpPath = path.resolve(__dirname, '..', '..','..','..', 'test-network', 'organizations', 'peerOrganizations', 'tradeassociation.ntuc.com', 'connection-tradeassociation.json');
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        var response = {};
        const identity = await wallet.get('TA');
        if (!identity) {
            console.log('An identity for the user "TA" does not exist in the wallet');
            console.log('Run the registerTA.js application before retrying');
            return;
        }
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'TA', discovery: { enabled: true, asLocalhost: true } });
        const network = await gateway.getNetwork('ntuc-channel');
        const contract = network.getContract('ntuc');
        const result = await contract.submitTransaction('IssueDigitalVoucher', TAmemberId,memberId,points);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        await gateway.disconnect();
        return result

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response;
    }
}
/***************************** purchase groceries using DV ************************************************/
exports.purchasegrocerry = async function(memberId,se_memberId,grocerr_item,points) {
    try {
        const ccpPath = path.resolve(__dirname, '..', '..','..','..', 'test-network', 'organizations', 'peerOrganizations', 'tradeunion.ntuc.com', 'connection-tradeunion.json');
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        var response = {};
        const identity = await wallet.get('TU');
        if (!identity) {
            console.log('An identity for the user "TU" does not exist in the wallet');
            console.log('Run the registerTU.js application before retrying');
            return;
        }
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'TU', discovery: { enabled: true, asLocalhost: true } });
        const network = await gateway.getNetwork('ntuc-channel');
        const contract = network.getContract('ntuc');
        const result = await contract.submitTransaction('purchasegrocerry', memberId,se_memberId,grocerr_item,points);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        await gateway.disconnect();
        return result

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        response.error = error.message;
        return response;
    }
}

//^^^^^^^^^^^^^^^^^^^^^^^^GET methods ***************************************************************/
/***************************** Get Member Data ************************************************/
exports.getmemberData = async function(memberId) {
    try {
        const ccpPath = path.resolve(__dirname, '..', '..','..','..', 'test-network', 'organizations', 'peerOrganizations', 'tradeunion.ntuc.com', 'connection-tradeunion.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        var response = {};
        const identity = await wallet.get('TU');
        if (!identity) {
            console.log('An identity for the user "TU" does not exist in the wallet');
            console.log('Run the registerTU.js application before retrying');
            return;
        }
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'TU', discovery: { enabled: true, asLocalhost: true } });
        const network = await gateway.getNetwork('ntuc-channel');
        const contract = network.getContract('ntuc');
        const result = await contract.evaluateTransaction('getmemberData', memberId);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        return result;

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        response.error = error.message;
        return response;
    }
}
/***************************** Get TA Data ************************************************/
exports.getTradeAssociationData = async function(TAmemberId) {
    try {
        const ccpPath = path.resolve(__dirname, '..', '..','..','..', 'test-network', 'organizations', 'peerOrganizations', 'tradeassociation.ntuc.com', 'connection-tradeassociation.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        var response = {};
        const identity = await wallet.get('TA');
        if (!identity) {
            console.log('An identity for the user "TA" does not exist in the wallet');
            console.log('Run the registerTA.js application before retrying');
            return;
        }
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'TA', discovery: { enabled: true, asLocalhost: true } });
        const network = await gateway.getNetwork('ntuc-channel');
        const contract = network.getContract('ntuc');
        const result = await contract.evaluateTransaction('getTradeAssociationData', TAmemberId);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        return result;

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        response.error = error.message;
        return response;
    }
}
/***************************** Get SE Data ************************************************/
exports.getSocialenterpriseData = async function(se_memberId) {
    try {
        const ccpPath = path.resolve(__dirname, '..', '..','..','..', 'test-network', 'organizations', 'peerOrganizations', 'socialenterprise.ntuc.com', 'connection-socialenterprise.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        var response = {};
        const identity = await wallet.get('SE');
        if (!identity) {
            console.log('An identity for the user "SE" does not exist in the wallet');
            console.log('Run the registerSE.js application before retrying');
            return;
        }
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'SE', discovery: { enabled: true, asLocalhost: true } });
        const network = await gateway.getNetwork('ntuc-channel');
        const contract = network.getContract('ntuc');
        const result = await contract.evaluateTransaction('getSocialenterpriseData', se_memberId);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        return result;

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        response.error = error.message;
        return response;
    }
}
