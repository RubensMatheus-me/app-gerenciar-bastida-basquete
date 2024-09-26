const createTables = [
  '''
    CREATE TABLE Player(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(200) NOT NULL,
      position VARCHAR(200) NOT NULL,
      tShirtNumber INTEGER NOT NULL,
      teamId INTEGER NOT NULL,
      FOREIGN KEY (teamId) REFERENCES Team(id)
    );
  ''',
  '''
    CREATE TABLE Team(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    );
  ''',
  '''
    CREATE TABLE Match (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      teamAId INTEGER NOT NULL,
      teamBId INTEGER NOT NULL,
      pointsTeamA INTEGER NOT NULL,
      pointsTeamB INTEGER NOT NULL,
      foulsTeamA INTEGER NOT NULL,
      foulsTeamB INTEGER NOT NULL,
      timer TEXT NOT NULL, 
      assists INTEGER NOT NULL,
      turnGame INTEGER NOT NULL,
      FOREIGN KEY (teamAId) REFERENCES Team(id),
      FOREIGN KEY (teamBId) REFERENCES Team(id)
    );
  ''',
  '''
    CREATE TABLE AfterMatch (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      matchId INTEGER NOT NULL,
      totalPoints INTEGER NOT NULL,
      totalFouls INTEGER NOT NULL,
      durationMatch TEXT NOT NULL,
      winner VARCHAR(50) NOT NULL,
      pointsDifference INTEGER NOT NULL,
      totalRebounds INTEGER NOT NULL,
      totalAssists INTEGER NOT NULL,
      totalTurnovers INTEGER NOT NULL,
      isWinner INTEGER NOT NULL,
      FOREIGN KEY (matchId) REFERENCES Match(id)
    );
  '''
];


const insertRegisters = [
  '''INSERT INTO Team (name) VALUES ('Team A');''',
  '''INSERT INTO Team (name) VALUES ('Team B');''',
  '''INSERT INTO Match (teamAId, teamBId, pointsTeamA, pointsTeamB, foulsTeamA, foulsTeamB, timer, turnGame) VALUES (1, 2, 21, 19, 5, 4, '2024-09-26T18:42:16.822717', 1);''',
  '''INSERT INTO AfterMatch (matchId, totalPoints, totalFouls, durationMatch, winner, pointsDifference, totalRebounds, totalAssists, totalTurnovers, isWinner) VALUES (1, 40, 9, '30:00', 'Team A', 2, 10, 8, 3, 1);''',
  '''INSERT INTO Player (name, position, tShirtNumber, teamId) VALUES ('Player 1', 'Guard', 10, 1);''',
  '''INSERT INTO Player (name, position, tShirtNumber, teamId) VALUES ('Player 2', 'Forward', 12, 1);''',
  '''INSERT INTO Player (name, position, tShirtNumber, teamId) VALUES ('Player 3', 'Center', 5, 2);''',
  '''INSERT INTO Player (name, position, tShirtNumber, teamId) VALUES ('Player 4', 'Forward', 7, 2);'''
];


