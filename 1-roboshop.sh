#31/bin/bash
AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-026381a5a2005e8e7"
INSTANCES=("MONGODB" "REDIS" "MYSQL" "RABBITNQ" "CATALOGUE" "USER" "CART" "SHIPPING" "PAYMENT" "DISPATCH" "FRONTEND")
ZONE_ID=Z08964191DFKFWEA2YRY0
DOMAIN_NAME="roboshop.bond"
for instance in ${INSTANCES[@]}
do 
  INSTANCE_ID=$(aws ec2 run-instances --image-id ami-0220d79f3f480ecf5 --instance-type t3.micro --security-group-ids sg-026381a5a2005e8e7 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query "Instances[0].InstanceId" --output text)
  if [ $instance != "frontend" ]
  then
      IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
  else
      IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
     fi
     echo "$instance IP Address:$IP"
done