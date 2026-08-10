R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USERID=$(id -u)
LOGS_FOLDER="/var/log/ravi.log"
SCRIPT_NAME="frontend.sh"
SCRIPT_DIR=$PWD
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
VALIDATE $? $Y"disabling the nginx"$N $LOG_FILE
dnf module enable nginx:1.24 -y 
VALIDATE $? $Y"enabling nginx"$N $LOG_FILE
dnf install nginx -y 
VALIDATE $? $Y"installing nginx"$N $LOG_FILE
systemctl enable nginx  
VALIDATE $? $Y"ENABLING NGINX SERVICE"$N
systemctl start nginx  
VALIDATE $? $Y"starting nginx service"$N $LOG_FILE
rm -rf /usr/share/nginx/html/*  
VALIDATE $? $Y"clearing nginx html directory"$N $LOG_FILE
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip 
VALIDATE $? $Y"downloading frontend zip file"$N $LOG_FILE
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip 
VALIDATE $? $Y"extracting frontend zip file"$N $LOG_FILE
rm -rf /etc/nginx/nginx.conf 
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.config 
systemctl restart nginx 
VALIDATE $? $Y"restarting nginx service"
