#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate table games, teams")

# read the games.csv for inserting into database
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
  TEAMS=$($PSQL "select name from teams where name='$WINNER'")
  if [[ $WINNER != "winner" ]]
    then
    if [[ -z $TEAMS ]]
      then
      INSERT_TEAM=$($PSQL "insert into teams(name) VALUES('$WINNER')")
      if [[ INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams: $WINNER
      fi
    fi
  fi

  TEAM_O=$($PSQL "select name from teams where name='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]
    then
    if [[ -z $TEAM_O ]]
      then
      INSERT_TEAM_O=$($PSQL "insert into teams(name) VALUES('$OPPONENT')")
      if [[ INSERT_TEAM_O == "INSERT 0 1" ]]
      then
        echo Inserted into teams: $OPPONENT
      fi
    fi
  fi

  TEAM_W_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  TEAM_O_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  
  if [[ -n $TEAM_W_ID || -n $TEAM_O_ID ]]
  then
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAMES=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', '$TEAM_W_ID', '$TEAM_O_ID', '$WINNER_G', '$OPPONENT_G')")
      if [[ $INSERT_GAMES == "INSERT 0 1" ]]
      then
        echo Inserted into games: $YEAR, $ROUND, $TEAM_W_ID, $TEAM_O_ID, $WINNER_G, $OPPONENT_G
      fi
    fi
  fi
done