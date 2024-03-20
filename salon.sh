#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\nWelcome to My Salon, how can I help you?\n"

SERVICE_LIST() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  LIST_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$LIST_SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    ID=$(echo $SERVICE_ID | sed 's/ //g')
    NAME=$(echo $SERVICE | sed 's/ //g')
    echo "$ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    [1-3]) NEXT ;;
        *) SERVICE_LIST "Please enter a valid option." ;;
  esac
}

# prompt users to enter a service_id, phone number, a name if they aren’t already a customer, and a time. You should use read to read these inputs into variables named SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME, and SERVICE_TIME
NEXT() {
echo -e "\nWhat is your phone number?"
read CUSTOMER_PHONE
ENTERED_PHONE=$($PSQL "select phone from customers where phone='$CUSTOMER_PHONE'")
# If a phone number entered doesn’t exist
 if [[ -z $ENTERED_PHONE ]]
 then
 # get the customers name 
  echo -e "\nWhat is your name?"
  read CUSTOMER_NAME
 # enter it, and the phone number, into the customers table
 NEW_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
 fi
 
 # get service_name formated
 SERVICE_NAME1=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
 SERVICE_NAME=$(echo $SERVICE_NAME1 | sed 's/ //g')
 # get customer_id and name formated
 CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
 NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
 CUSTOMER_NAME=$(echo $NAME | sed 's/ //g')
 # get service time
 echo -e "\nWhat time would you like your service?"
 read SERVICE_TIME
  
 # insert into appointments table
 NEW_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
 echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}


SERVICE_LIST