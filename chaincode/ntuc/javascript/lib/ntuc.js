'use strict';
const { Contract} = require('fabric-contract-api');
var base64 = require('base-64');
class ntuc extends Contract {
  async init(ctx) {
  
    console.log("<== ntuc Chaincode==>");
    
     }
/***************************** Create Member ************************************************/
async createMember(ctx, memberId, accountNumber,firstName,lastName,email,phoneNumber) {
  let userAsBytes = await ctx.stub.getState(memberId); 
  if (!userAsBytes || userAsBytes.toString().length <= 0) {
    let member = {
      MemberId:memberId,
      AccountNumber:accountNumber,
      FirstName:firstName,
      LastName:lastName,
      Email:email,
      PhoneNumber:phoneNumber,
      Availablepoints:'0',
      DigitalVoucher:[],
      Voucherused : []
    }
    await ctx.stub.putState(memberId, Buffer.from(JSON.stringify(member)));
  console.info('============= END : notary data put into BLOCKCHAIN ===========');
  let response = {
    MemberId:memberId,
    AccountNumber:accountNumber,
    FirstName:firstName,
    LastName:lastName,
    Email:email,
    PhoneNumber:phoneNumber,
    success : 'true',
    message : member.FirstName + " registed in NTUC Blockchain"
  }
  return JSON.stringify(response);
}
else {
  return ({Error: memberId+ " already registerred..!!"});
}
}

/***************************** register trade association ************************************************/

async registerTradeAssociation(ctx,TAmemberId, name) {
let userAsBytes = await ctx.stub.getState(TAmemberId); 
if (!userAsBytes || userAsBytes.toString().length <= 0) {
let member = {
  TAmemberId:TAmemberId,
  Name:name,
  VoucherIssued:[]
}
await ctx.stub.putState(TAmemberId, Buffer.from(JSON.stringify(member)));
console.info('============= END : notary data put into BLOCKCHAIN ===========');
let response = {
TAmemberId:TAmemberId,
Name:name,
success : 'true',
message : member.Name + " registed in NTUC Blockchain"
}
return JSON.stringify(response);
}
else {
return ({Error: TAmemberId+ " already registerred..!!"});
}
}
/***************************** register social enterprise ************************************************/
async registerSocialEnterprise(ctx,se_memberId, name) {
let userAsBytes = await ctx.stub.getState(se_memberId); 
if (!userAsBytes || userAsBytes.toString().length <= 0) {
let member = {
  SE_memberId:se_memberId,
  Name:name,
  Purchases:[]
}
await ctx.stub.putState(se_memberId, Buffer.from(JSON.stringify(member)));
console.info('============= END : notary data put into BLOCKCHAIN ===========');
let response = {
SE_memberId:se_memberId,
Name:name,
success : 'true',
message : member.Name + " registed in NTUC Blockchain"
}
return JSON.stringify(response);
}
else {
return ({Error: se_memberId+ " already registerred..!!"});
}
}
/***************************** Create and Issue Digital voucher ************************************************/
async IssueDigitalVoucher(ctx,TAmemberId,memberId,points) {
// let timeStamp= await ctx.stub.getTxTimestamp();
// const timestamp = new Date(timeStamp.getTime()).toISOString();
const timestamp = new Date((ctx.stub.txTimestamp.seconds.low*1000)).toGMTString();
let userAsBytes = await ctx.stub.getState(TAmemberId); 
if (!userAsBytes || userAsBytes.toString().length <= 0){
return({Error: "Incorrect TAmemberId..!"});
}
let buyerAsBytes = await ctx.stub.getState(memberId); 
if (!buyerAsBytes || buyerAsBytes.toString().length <= 0){
return({Error: "Incorrect memberId..!"});
}
else {
let Data = {
  TAmemberId:TAmemberId,
  MemberId:memberId,
  Points:points,
  VoucherDate:timestamp,
  VoucherHash:"",
  tx_id: ctx.stub.getTxID(),
}
let inputdata = JSON.stringify(Data);
var encoded = base64.encode(inputdata);
Data.VoucherHash = encoded;
let Seller = JSON.parse(buyerAsBytes);
Seller.DigitalVoucher.length = 0;
Seller.Availablepoints = Data.Points;
Seller.DigitalVoucher.push(Data);
await ctx.stub.putState(memberId, Buffer.from(JSON.stringify(Seller)));
let vouvherIssue = JSON.parse(userAsBytes);
vouvherIssue.VoucherIssued.push(Data);
await ctx.stub.putState(TAmemberId, Buffer.from(JSON.stringify(vouvherIssue)));
let response = {
TAmemberId:TAmemberId,
VoucherHash: Data.VoucherHash,
success : 'true',
tx_id:Data.tx_id
}
return JSON.stringify(response);
}
}

/***************************** purchase groceries using DV ************************************************/
async purchasegrocerry(ctx,memberId,se_memberId,grocerr_item,points) {
// let timeStamp= await ctx.stub.getTxTimestamp();
// const timestamp = new Date(timeStamp.getTime()).toISOString();
const timestamp = new Date((ctx.stub.txTimestamp.seconds.low*1000)).toGMTString();
let memberAsBytes = await ctx.stub.getState(memberId); 
let check = JSON.parse(memberAsBytes);
if (!memberAsBytes || memberAsBytes.toString().length <= 0){
  return({Error: "Incorrect memberId..!"});
}
// if(points < check.Availablepoints){
//   return({Error: "Insufficient points"})
// }
let seAsBytes = await ctx.stub.getState(se_memberId); 
if (!seAsBytes || seAsBytes.toString().length <= 0){
  return({Error: "Incorrect se_memberId..!"});
}
 else {
  let Data = {
    MemberId:memberId,
    SE_memberId:se_memberId,
    Grocerr_item:grocerr_item,
    VoucherDate:check.DigitalVoucher[0].VoucherDate,
    VoucherUsedDate:timestamp,
    VoucherHash:check.DigitalVoucher[0].VoucherHash,
    points:points,
    tx_id: ctx.stub.getTxID(),
  }
let SEnterprise = JSON.parse(seAsBytes);
SEnterprise.Purchases.push(Data);
await ctx.stub.putState(se_memberId, Buffer.from(JSON.stringify(SEnterprise)));
// memberdata.Voucherused.length = 0;
let remainingpoints = check.Availablepoints-points;
check.Availablepoints = remainingpoints;
check.Voucherused.push(Data);
await ctx.stub.putState(memberId, Buffer.from(JSON.stringify(check)));
let response = {
  MemberId:Data.MemberId,
  SE_memberId : Data.SE_memberId,
  VoucherHash: Data.VoucherHash,
  success : 'true',
  Availablepoints: remainingpoints,
  tx_id:Data.tx_id
}
return JSON.stringify(response);
}
}
/***************************** Get Member Data ************************************************/
async getmemberData(ctx,memberId) {
 
let userAsBytes = await ctx.stub.getState(memberId); 
if (!userAsBytes || userAsBytes.toString().length <= 0) {
return({Error: "Incorrect memberId..!"});
    }
else {
let data=JSON.parse(userAsBytes.toString());
console.log(data);
return JSON.stringify(data);
   }
 }
/***************************** Get TA Data ************************************************/
async getTradeAssociationData(ctx,TAmemberId) {
 
let userAsBytes = await ctx.stub.getState(TAmemberId); 
if (!userAsBytes || userAsBytes.toString().length <= 0) {
return({Error: "Incorrect memberId..!"});
   }
else {
let data=JSON.parse(userAsBytes.toString());
console.log(data);
return JSON.stringify(data);
  }
}
/***************************** Get SE Data ************************************************/
async getSocialenterpriseData(ctx,se_memberId) {
 
let userAsBytes = await ctx.stub.getState(se_memberId); 
if (!userAsBytes || userAsBytes.toString().length <= 0) {
return({Error: "Incorrect se_memberId..!"});
    }
else {
let data=JSON.parse(userAsBytes.toString());
console.log(data);
return JSON.stringify(data);
   }
 }
}

module.exports = ntuc;