#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Bike Rental Shop ~~~~~\n"


RENT_MENU() {
  # get available bikes
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  # if no bikes available
  if [[ -z $AVAILABLE_SERVICES ]]
  then
    # send to main menu
    RENT_MENU "Sorry, we don't have any bikes available right now."
  else
    # display available bikes
    echo -e "\nWelcome to My Salon, how can I help you?"
    echo "$AVAILABLE_SERVICES" | while read BIKE_ID BAR TYPE
    do
      echo "$BIKE_ID) $TYPE"
    done
  fi  

  # ask for bike to rent
  echo -e "\nWhich one would you like to have?"
  read SERVICE_ID_SELECTED

  # if input is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      # send to main menu
      RENT_MENU "That is not a valid service number."
    else
      # get bike availability
      SERVICE_AVAILABILITY=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

       # if not available
      if [[ -z $SERVICE_AVAILABILITY ]]
      then
        # send to main menu
        RENT_MENU "That service is not available."
      else
        # get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME

          

          # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
        fi

        

        # get customer_id
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
        
        # get customer service time
          echo -e "\nWhat's your time availability?"
          read SERVICE_TIME


        # insert service reserved
        INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments(customer_id, time, service_id) VALUES($CUSTOMER_ID, '$SERVICE_TIME', $SERVICE_ID_SELECTED)")

        # set bike availability to false
        #SET_TO_FALSE_RESULT=$($PSQL "UPDATE bikes SET available = false WHERE bike_id = $BIKE_ID_TO_RENT")

        # get bike info
        SERVICE_INFO=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        #BIKE_INFO_FORMATTED=$(echo $BIKE_INFO | sed 's/ |/"/')
        
        # send to main menu
        echo "I have put you down for a $SERVICE_INFO at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
        EXIT
      fi
    fi
  
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

RENT_MENU
