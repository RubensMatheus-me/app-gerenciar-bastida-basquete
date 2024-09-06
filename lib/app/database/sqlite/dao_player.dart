import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/interface/dao_player.dart';
import 'package:sqflite/sqflite.dart';

class DaoPlayer implements IDAOPlayer {
  late Database _db;

  @override
  Future<DTOPlayer> remove(id) {
    throw UnimplementedError();
  }

  @override
  Future<DTOPlayer> save(DTOPlayer dto) async {
    _db = await Connection.openDb();
    int id = await _db
        .rawInsert('''INSERT INTO player (name, position, tShirtNumber, team)
      VALUES (?, ?, ?, ?) 
      ''', [dto.name, dto.position, dto.tShirtNumber, dto.association]);
    dto.id = id;
    return dto;
  }

  @override
  Future<List<Player>> search() {
    // TODO: implement search
    throw UnimplementedError();
  }
}
