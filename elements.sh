#!/bin/bash

# Provide an argument
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
PASS_ARGUMENT=$1

SEARCH_PERIODIC() {
  # check if argument provided
  
  #AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  #echo "$PASS_ARGUMENT"
  # if no bikes available
  if [[ -z $PASS_ARGUMENT ]]
  then
    # send to main menu
  echo -e "Please provide an element as an argument."
  else
    # check if argument is valide
    # check if not a number
    if [[ ! $PASS_ARGUMENT =~ ^[0-9]+$ ]]
    then
    #search for symbol
    #echo "le pass $PASS_ARGUMENT"
    SYMBOL_AVAILABLE=$($PSQL "SELECT symbol FROM elements WHERE symbol='$PASS_ARGUMENT'")
    #echo $SYMBOL_AVAILABLE
    NAME_AVAILABLE=$($PSQL "SELECT name FROM elements WHERE name='$PASS_ARGUMENT'") 
    #echo "le name$NAME_AVAILABLE"
       if [[ -z $SYMBOL_AVAILABLE ]] && [[ -z $NAME_AVAILABLE ]]
       then
       EXIT
       # check name
       
       elif [[ -z $SYMBOL_AVAILABLE ]]
          then
            
          #avec name
          DATA_TO_DISPLAY=$($PSQL "SELECT atomic_number,symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$PASS_ARGUMENT'")
             if [[ -z DATA_TO_DISPLAY ]]
             then
             EXIT
             else
             echo "$DATA_TO_DISPLAY" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
             do
             echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
             done
             fi
          
       else 
          #avec symbol
          
          DATA_TO_DISPLAY=$($PSQL "SELECT atomic_number,symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$PASS_ARGUMENT'")
              if [[ -z DATA_TO_DISPLAY ]]
              then
              EXIT
              else
              echo "$DATA_TO_DISPLAY" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
              do
              echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
              done
              fi
        
       fi
    else   
    
    #avec atomic number
          
          
          #CHECK_ATOM= $($PSQL "SELECT name FROM elements WHERE atomic_number=$PASS_ARGUMENT")
          DATA_TO_DISPLAY_ATO=$($PSQL "SELECT atomic_number,symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$PASS_ARGUMENT")
          #echo $PASS_ARGUMENT
          #echo $DATA_TO_DISPLAY_ATO
          if [[ -z $DATA_TO_DISPLAY_ATO ]]
              then
              EXIT
              else
              #DATA_TO_DISPLAY_ATO=$($PSQL "SELECT atomic_number,symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$PASS_ARGUMENT")
              echo "$DATA_TO_DISPLAY_ATO" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
              do
              echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
              done
              fi


    fi
  fi
}



EXIT() {
  echo -e "I could not find that element in the database."
}



SEARCH_PERIODIC