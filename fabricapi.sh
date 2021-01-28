cd ntuc/javascript/wallet

rm -rf *

echo "wallet keys has ben deleted"
echo
cd ../
sleep 2
echo "run enroll admin for Trade Union"
node enrollAdminTU.js
echo
echo "Run register user for Trade Union"
node registerUserTU.js
echo
echo "run enroll admin for Trade Association"
node enrollAdminTA.js
echo
echo "Run register user for Trade Association"
node registerUserTA.js
echo
echo "run enroll admin for Social Enterprice"
node enrollAdminSE.js
echo
echo "Run register user for Social Enterprice"
node registerUserSE.js
echo
echo "start npm"
echo
npm start