R="\e{31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
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
echo -e  "$2 is $Gsuccessful$N"
else
echo -e "$2 is $Rfailure$N"
fi
}
cp mongodb.repo /etc/yum.repos.d/mongo.repo
 VALIDATE $? $Y"copying the Repo"$N
dnf install mongodb-org -y 
VALIDATE $? $Y"Installing MongoDB"$N
systemctl enable mongod 
VALIDATE $? $Y"enabling mongod"$N
systemctl start mongod 
VALIDATE $? $Y"starting mongod"$N
sed -i 's/127..0.0.1/0.0.0.0/g' /etc/mongod.conf
systemctl restart mongod
VALIDATE $? $Y"restarting mongodb"$N