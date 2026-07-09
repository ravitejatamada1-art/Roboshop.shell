R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USERID=$(id -u)
LOGS_FOLDER="/var/log/Roboshop-logs"
SCRIPT_NAME="mongodb.log"
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME"
mkdir -p $LOGS_FOLDER
if [ $USERID -eq 0 ]
then 
echo "you are Running with Root User" |tee -a $LOG_FILE
else
echo "Please run with Root User" |tee -a $LOG_FILE
fi
VALIDATE()
{
if [ $1 -eq 0 ]
then 
echo -e  "$2 is $G"successful"$N" | tee -a $LOG_FILE
else
echo -e "$2 is $R"failure"$N" | tee -a $LOG_FILE
fi
}
dnf module disable nodejs -y
VALIDATE $? $Y"disabling the nodejs"$N
dnf module enable nodejs:20 -y
VALIDATE $? $Y"enabling nodejs"$N
dnf install nodejs -y
VALIDATE $? $Y"INSTALLING node js"$N
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? $Y"creating roboshop user"$N
mkdir -p /app 
VALIDATE $? $Y"creating app directory"$N
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? $Y"downloading Zip file"$N
cd /app 
unzip /tmp/catalogue.zip
VALIDATE $? $Y"extracting catalogue zip file"$N
npm install 
VALIDATE $? $Y"installing npm dependencies"$N
[Unit]
Description = Catalogue Service

cp catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? $Y"installing catalogue service"$N
systemctl daemon-reload
VALIDATE $? $Y"reloading systemd daemon"$N
systemctl enable catalogue 
VALIDATE $? $Y"ENABLING CATALOGUE SERVICE"$N
systemctl start catalogue
VALIDATE $? $Y"starting catalogue service"$N
cp mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? $Y"installing mongodb repository"$N
dnf install mongodb-mongosh -y
VALIDATE $? $Y"INSTALLING MONGODB client"$N
mongosh --host mongodb.Roboshop.bond </app/db/master-data.js
