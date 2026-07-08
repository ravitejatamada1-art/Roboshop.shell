USERID=$(id -u)
if [ $USERID -eq 0 ]
then 
echo "you are Running with Root User"
else
echo "Please run with Root User"
fi
VALIDATE()
{
if [ $1 -eq 0 ]
then 
echo "$2 is successful"
else
echo "$2 is failure"
fi
}
cp mongodb.repo /etc/yum.repos.d/mongo.repo
 VALIDATE $? "copying the Repo"
dnf install mongodb-org -y 
VALIDATE $? "Installing MongoDB"
systemctl enable mongod 
VALIDATE $? "enabling mongod"
systemctl start mongod 
VALIDATE $? "starting mongod"
sed -i 's/127..0.0.1/0.0.0.0/g' /etc/mongod.conf
systemctl restart mongod
VALIDATE $? "restarting mongodb"