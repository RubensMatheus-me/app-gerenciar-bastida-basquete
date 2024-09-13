import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/interface/dao_player.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoPlayer implements IDAOPlayer {
  late Database _db;

  ImpDaoPlayer(this._db);

  @override
  Future<DTOPlayer?> remove(dynamic id) async {
    _db = await Connection.openDb();
    var sql = 'DELETE FROM player WHERE id = ?';
    _db.rawDelete(sql, [id]);
  }

  @override
  Future<DTOPlayer> save(DTOPlayer dto) async {
    _db = await Connection.openDb();
    int id = await _db
        .rawInsert('''INSERT INTO player (name, position, tShirtNumber, team)
      VALUES (?, ?, ?, ?) 
      ''', [dto.name, dto.position, dto.tShirtNumber, dto.association.name]);

    dto.id = id;
    return dto;
  }

  @override
  Future<List<Player>> search() async {
    _db = await Connection.openDb();

    List<Map<String, dynamic>> result = await _db.query('player');

    List<Player> list = List.generate(result.length, (i) {
      var line = result[i];
      return Player(
        id: line['id'],
        name: line['name'],
        position: line['position'],
        tShirtNumber: line['tShirtNumber'],
        association: line['team'],
      );
    });
    return list;
  }
}
