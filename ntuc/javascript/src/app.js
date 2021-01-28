const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const morgan = require('morgan')

var network = require('./fabric/network.js');

const app = express()
app.use(morgan('combined'))
app.use(bodyParser.json())
app.use(cors())

/******************BLOCKCHAIN END POINTS START HERE ******************************************/
app.post('/createMember', (req, res) => { 
  console.log(req.body);    
      network.createMember(
        req.body.memberId,
        req.body.accountNumber,
        req.body.firstName,
        req.body.lastName,
        req.body.email,
        req.body.phoneNumber)
      .then((response) => {
        res.send(response)
      });
    })  

app.post('/registerTradeAssociation',(req,res) => {
  console.log(req.body);
     network.registerTradeAssociation(
       req.body.TAmemberId,
       req.body.name)
      .then((response) => {
        res.send(response)
      });
})

app.post('/registerSocialEnterprise',(req,res) => {
  console.log(req.body);
     network.registerSocialEnterprise(   
       req.body.se_memberId,
       req.body.name)
      .then((response) => {
        res.send(response)
      });
})

app.post('/IssueDigitalVoucher',(req,res) => {
  console.log(req.body);
     network.IssueDigitalVoucher(   
       req.body.TAmemberId,
       req.body.memberId,
       req.body.points)
      .then((response) => {
        res.send(response)
      });
})

app.post('/purchasegrocerry',(req,res) => {
  console.log(req.body);
     network.purchasegrocerry(
      req.body.memberId,
      req.body.se_memberId,
      req.body.grocerr_item,
      req.body.points)
      .then((response) => {
        res.send(response)
      });
})

app.get('/getmemberData', (req, res) => {
   console.log(req);
   network.getmemberData(req.body.memberId)
   .then((response) => {           
   res.send(response)
   console.log(response);
     });
  })

  app.get('/getTradeAssociationData', (req, res) => {
    console.log(req);
    network.getTradeAssociationData(req.body.TAmemberId)
    .then((response) => {           
    res.send(response)
    console.log(response);
      });
   })

app.get('/getSocialenterpriseData', (req, res) => {
   console.log(req);
   network.getSocialenterpriseData(req.body.se_memberId)
     .then((response) => {           
        res.send(response)
        console.log(response);
       });
  })

app.listen(process.env.PORT || 8081)
