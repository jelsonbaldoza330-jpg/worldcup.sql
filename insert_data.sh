#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

query=""
while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  query+="INSERT INTO teams(name) VALUES('$winner'),('$opponent') ON CONFLICT (name) DO NOTHING; "
  query+="INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', (SELECT team_id FROM teams WHERE name = '$winner'), (SELECT team_id FROM teams WHERE name = '$opponent'), $winner_goals, $opponent_goals); "
done < <(tail -n +2 games.csv)

$PSQL "$query" > /dev/null
