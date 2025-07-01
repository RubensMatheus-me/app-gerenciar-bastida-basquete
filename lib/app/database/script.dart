const tables = [
  '''
  CREATE TABLE team (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE player (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    shirtNumber INTEGER NOT NULL,
    position TEXT NOT NULL,
    teamId INTEGER NOT NULL,
    FOREIGN KEY (teamId) REFERENCES team(id) ON DELETE CASCADE
  );
  ''',
  '''
  CREATE TABLE match (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timer INTEGER NOT NULL,
    maxPoints INTEGER NOT NULL,
    winner TEXT,
    matchTypeIndex INTEGER NOT NULL
  );
  ''',
  '''
  CREATE TABLE assertiveness_pitch (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE distance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    distance TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE pitches (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pitches TEXT NOT NULL,
    distanceId INTEGER NOT NULL,
    zoneType TEXT NOT NULL,
    FOREIGN KEY (distanceId) REFERENCES distance(id) ON DELETE CASCADE
  );
  ''',
  '''
  CREATE TABLE player_statistics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    points INTEGER NOT NULL,
    zonePoint TEXT NOT NULL,
    assertivenessPitchId INTEGER NOT NULL,
    matchId INTEGER NOT NULL,
    playerId INTEGER NOT NULL,
    FOREIGN KEY (assertivenessPitchId) REFERENCES assertiveness_pitch(id) ON DELETE CASCADE,
    FOREIGN KEY (matchId) REFERENCES match(id) ON DELETE CASCADE,
    FOREIGN KEY (playerId) REFERENCES player(id) ON DELETE CASCADE
  );
  ''',
  '''
  CREATE TABLE type_match (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE position (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    position TEXT NOT NULL
  );
  ''',
];

const inserts = [
  '''INSERT INTO team (name) VALUES ('Time A');''',
  '''INSERT INTO team (name) VALUES ('Time B');''',

  '''INSERT INTO player (name, position, shirtNumber, teamId) VALUES ('Rubens', 'alaArmador', 10, 1);''',
  '''INSERT INTO player (name, position, shirtNumber, teamId) VALUES ('Hélio', 'armador', 12, 1);''',
  '''INSERT INTO player (name, position, shirtNumber, teamId) VALUES ('Daniels', 'pivo', 1, 1);''',

  '''INSERT INTO player (name, position, shirtNumber, teamId) VALUES ('Gustavo', 'pivo', 5, 2);''',
  '''INSERT INTO player (name, position, shirtNumber, teamId) VALUES ('Mateus Back', 'alaArmador', 7, 2);''',
  '''INSERT INTO player (name, position, shirtNumber, teamId) VALUES ('Marcelo', 'armador', 8, 2);''',

'''INSERT OR IGNORE INTO assertiveness_pitch (id, description) VALUES (1, 'Acerto');''',
'''INSERT OR IGNORE INTO assertiveness_pitch (id, description) VALUES (2, 'Erro');''',
];