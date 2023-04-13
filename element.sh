#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT=$1
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

# if input is an atomic number
if [[ $ELEMENT =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = '$1'");
  else
  #if input is symbol or name
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'");
  # if element does not exist in database
fi  

if [[ -z $ELEMENT ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

# output
echo $ELEMENT | while IFS=" |" read atomic_number name symbol type atomic_mass melting_point_celsius boiling_point_celsius
do
echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
done
