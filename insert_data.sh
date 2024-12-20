#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # get winner team
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert winner team
      echo "Trying to insert $WINNER"
      INSERTED_WINNER=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERTED_WINNER == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
      fi

      # get winner team
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi

    # get opponent team
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    # if not found
      # insert opponent team
      INSERTED_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERTED_OPPONENT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $OPPONENT"
      fi

      # get opponent team
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    
    # insert game
    INSERTED_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERTED_GAME == "INSERT 0 1" ]]
    then
      echo "Inserted into games, $WINNER $WINNER_GOALS-$OPPONENT_GOALS $OPPONENT"
    fi
  fi
done
