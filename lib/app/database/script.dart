const createTables = [
  '''
    CREATE TABLE players(
      id INTEGER NOT NULL PRIMARY KEY,
      name VARCHAR(200) NOT NULL,
      position VARCHAR(20) NOT NULL,
      tShirtNumber INTEGER NOT NULL,
      team CHAR(5) NOT NULL
    )
  ''',
  '''
    CREATE TABLE team(
      id INTEGER NOT NULL PRIMARY KEY,
      name CHAR(5) NOT NULL,
      players VARCHAR(200) NOT NULL,
    )
  '''
];

const insertRegisters = [
  'INSERT INTO players (name, position, tShirtNumber) VALUES ("Joao", "Ala-Armador", 00)',
  'INSERT INTO players (name, position, tShirtNumber) VALUES ("Rubens", "Armador", 01)',
  'INSERT INTO players (name, position, tShirtNumber) VALUES ("Gustavo", "Pivo", 02)',
  'INSERT INTO players (name, position, tShirtNumber) VALUES ("Back", "Armador", 03)'
];
