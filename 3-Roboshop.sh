R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USERID=$(id -u)
FOLDER_NAME="/var/log/Roboshop-logs"
SCRIPT_NAME=mongodb.log
LOG_FILE="$FOLDER_NAME/$SCRIPT_NAME"
makedir -p $FOLDER_NAME
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
cp mongodb.repo /etc/yum.repos.d/mongo.repo
 VALIDATE $? $Y"copying the Repo"$N
dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? $Y"Installing MongoDB"$N | tee -a $LOG_FILE
systemctl enable mongod &>>$LOG_FILE
VALIDATE $? $Y"enabling mongod"$N | tee -a $LOG_FILE
systemctl start mongod &>>$LOG_FILE
VALIDATE $? $Y"starting mongod"$N | tee -a $LOG_FILE
sed -i 's/127..0.0.1/0.0.0.0/g' /etc/mongod.conf
systemctl restart mongod &>>$LOG_FILE
VALIDATE $? $Y"restarting mongodb"$N |tee -a $LOG_FILE   