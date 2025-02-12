#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]; then
  if [[ $1 =~ ^[0-9]+$ ]]; then
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                     FROM elements 
                     JOIN properties USING(atomic_number) 
                     JOIN types USING(type_id) 
                     WHERE atomic_number = $1")
  else
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                     FROM elements 
                     JOIN properties USING(atomic_number) 
                     JOIN types USING(type_id) 
                     WHERE symbol = '$1' OR name = '$1'")
  fi

  if [[ -z $ELEMENT ]]; then
    echo "I could not find that element in the database."
  else
   echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELTING BOILING;

    do
     echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi
