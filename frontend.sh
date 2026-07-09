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
dnf module disable nginx -y
VALIDATE $? $Y"disabling the nginx"$N
dnf module enable nginx:1.24 -y
VALIDATE $? $Y"enabling nginx"$N
dnf install nginx -y
VALIDATE $? $Y"installing nginx"$N
systemctl enable nginx 
VALIDATE $? $Y"ENABLING NGINX SERVICE"$N
systemctl start nginx 
VALIDATE $? $Y"starting nginx service"$N
rm -rf /usr/share/nginx/html/* 
VALIDATE $? $Y"clearing nginx html directory"$N
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? $Y"downloading frontend zip file"$N
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? $Y"extracting frontend zip file"$N
cp nginx.conf /etc/nginx/nginx.conf
systemctl restart nginx 
VALIDATE $? $Y"restarting nginx service"$N
