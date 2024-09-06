const createTables = [
  '''
    CREATE TABLE player(
      id INTEGER NOT NULL PRIMARY KEY,
      name VARCHAR(200) NOT NULL,
      position VARCHAR(20) NOT NULL,
      tShirtNumber INTEGER NOT NULL,
      team CHAR(5) NOT NULL
    );
  ''',
  '''
    CREATE TABLE team(
      id INTEGER NOT NULL PRIMARY KEY,
      name CHAR(5) NOT NULL,
      player VARCHAR(200) NOT NULL
    );
  '''
];

const insertRegisters = [
  'INSERT INTO player (name, position, tShirtNumber, team) VALUES ("Joao", "Ala-Armador", 00, "teamA")',
  'INSERT INTO player (name, position, tShirtNumber, team) VALUES ("Rubens", "Armador", 01, "teamA")',
  'INSERT INTO player (name, position, tShirtNumber, team) VALUES ("Gustavo", "Pivo", 02, "teamA")',
  'INSERT INTO player (name, position, tShirtNumber, team) VALUES ("Back", "Armador", 03, "teamA")'
];
