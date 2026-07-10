R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USERID=$(id -u)
LOGS_FOLDER="/var/log/Roboshop-logs"
SCRIPT_NAME="mongodb.log"
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME"
mkdir -p $LOGS_FOLDER
SCRIPT_DIR=$PWD
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
dnf module disable nodejs -y  &>>$LOG_FILE
VALIDATE $? $Y"disabling the nodejs"$N $LOG_FILE
dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? $Y"enabling nodejs"$N $LOG_FILE
dnf install nodejs -y  &>>$LOG_FILE
VALIDATE $? $Y"INSTALLING node js"$N $LOG_FILE
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? $Y"creating roboshop user"$N $LOG_FILE
mkdir /app 
VALIDATE $? $Y"creating app directory"$N $LOG_FILE
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? $Y"downloading Zip file"$N $LOG_FILE
cd /app 
unzip /tmp/catalogue.zip
VALIDATE $? $Y"extracting catalogue zip file"$N $LOG_FILE
npm install  &>>$LOG_FILE
VALIDATE $? $Y"installing npm dependencies"$N $LOG_FILE
rm -rf /etc/systemd/system/catalogue.service
cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? $Y"installing catalogue service"$N $LOG_FILE
systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? $Y"reloading systemd daemon"$N $LOG_FILE
systemctl enable catalogue  &>>$LOG_FILE
VALIDATE $? $Y"ENABLING CATALOGUE SERVICE"$N $LOG_FILE
systemctl start catalogue &>>$LOG_FILE
VALIDATE $? $Y"starting catalogue service"$N $LOG_FILE
cp mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? $Y"installing mongodb repository"$N $LOG_FILE
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? $Y"INSTALLING MONGODB client"$N $LOG_FILE
mongosh --host mongodb.Roboshop.bond </app/db/master-data.js
