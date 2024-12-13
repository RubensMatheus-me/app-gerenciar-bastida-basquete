const createTables = [
  '''
    CREATE TABLE Player(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(200) NOT NULL,
      position VARCHAR(200) NOT NULL,
      tShirtNumber INTEGER NOT NULL,
      points INTEGER,
      rebounds INTEGER,
      assists INTEGER,
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
      timer INTEGER NOT NULL, 
      assists INTEGER NOT NULL,
      isCompleted BOOLEAN NOT NULL,
      turnGame INTEGER NOT NULL,
      FOREIGN KEY (teamAId) REFERENCES Team(id),
      FOREIGN KEY (teamBId) REFERENCES Team(id)
    );
  ''',
  '''
    CREATE TABLE PlayerMatchStats (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      playerId INTEGER NOT NULL,
      matchId INTEGER NOT NULL,
      points INTEGER NOT NULL,
      rebounds INTEGER,
      assists INTEGER,
      FOREIGN KEY (playerId) REFERENCES Player(id),
      FOREIGN KEY (matchId) REFERENCES Match(id)
    );
  '''
      '''
    CREATE TABLE AfterMatch (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      matchId INTEGER NOT NULL,
      totalPoints INTEGER NOT NULL,
      totalFouls INTEGER NOT NULL,
      durationMatch INTEGER NOT NULL,
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
  '''INSERT INTO Player (name, position, tShirtNumber, points, rebounds, assists, teamId) VALUES ('Rubens', 'Ala-Armador', 10, 0, 2, 3, 1);''',
  '''INSERT INTO Player (name, position, tShirtNumber, points, rebounds, assists, teamId) VALUES ('Hélio', 'Armador', 12, 0, 3, 1, 1);''',
  '''INSERT INTO Player (name, position, tShirtNumber, points, rebounds, assists, teamId) VALUES ('Gustavo', 'Pívô', 5, 0, 0, 0, 2);''',
  '''INSERT INTO Player (name, position, tShirtNumber, points, rebounds, assists, teamId) VALUES ('Mateus Back', 'Ala-Pivô', 7, 0, 1, 1, 2);''',
  '''INSERT INTO Match (teamAId, teamBId, pointsTeamA, pointsTeamB, foulsTeamA, foulsTeamB, timer, assists, turnGame, isCompleted) VALUES (1, 2, 100, 90, 15, 10, 600, 25, 1, 1);''',
  '''INSERT INTO PlayerMatchStats (playerId, matchId, points, rebounds, assists) VALUES (1, 1, 30, 2, 3);''',
  '''INSERT INTO PlayerMatchStats (playerId, matchId, points, rebounds, assists) VALUES (2, 1, 25, 3, 1);''',
  '''INSERT INTO PlayerMatchStats (playerId, matchId, points, rebounds, assists) VALUES (3, 1, 20, 0, 0);''',
  '''INSERT INTO PlayerMatchStats (playerId, matchId, points, rebounds, assists) VALUES (4, 1, 25, 1, 1);'''
];
