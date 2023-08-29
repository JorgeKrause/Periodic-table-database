#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

ELEMENT_SEARCHER() {
  if [[  $INPUT =~ ^[0-9]+$ ]]
  then 
    SEARCH_FOR_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT")
    if [[ -z $SEARCH_FOR_ELEMENT ]]
    then
      echo "I could not find that element in the database."
    else
      INFO_ELEMENTS=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$INPUT")
      echo  "$INFO_ELEMENTS" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  else
    SEARCH_FOR_ELEMENT=$($PSQL "SELECT symbol FROM elements WHERE symbol='$INPUT' OR name='$INPUT'")
    if [[ -z $SEARCH_FOR_ELEMENT ]]
    then
      echo "I could not find that element in the database."
    else
      INFO_ELEMENTS=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$INPUT' OR name='$INPUT'")
      echo  "$INFO_ELEMENTS" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  fi
  
}



if [[ $1 ]]
then
  INPUT=$1
  ELEMENT_SEARCHER
else
  echo "Please provide an element as an argument."
fi
