#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE teams, games")
# Do not change code above this line. Use the PSQL variable above to query your database.
sed 1,1d games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  # get existing team_id from table
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # insert teams
  if [[ -z $TEAM_ID ]] 
  then
    # echo $OPPONENT
    # insert OPPONENT from file (all teams will be present because we have only one winner)
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
   # INSERT_TEAMS_RESULT1=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_NAME_OPPONENT')")
  fi
  # to add the winner we shoud check where round = final
  if [[ $ROUND = "Final" ]]
  then
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # insert winner of the tournament
    # echo $WINNER_TEAM_ID
    INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')" )
  fi
 

done

sed 1,1d games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
# insert into games table
  # find the winner_id and opponent_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  #echo $WINNER_ID " vs " $OPPONENT_ID
  if [[ $OPPONENT_ID != ""  || $WINNER != "" ]]
  then
    
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi
done  