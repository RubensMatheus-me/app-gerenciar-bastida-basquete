import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/interface/dao_team.dart';
import 'package:flutter/material.dart';

class TeamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Times'),
        ),
        body: FutureBuilder(
          future: ImpDaoTeam().getAllTeams(),
          builder: (context, AsyncSnapshot<List<DTOTeam>> consult) {
            var dados = consult.data;
            if (dados == null) {
              return Text('dados não encontrados');
            } else {
              List<DTOTeam> list = dados;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var team = list[index];
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(team.name),
                  );
                },
              );
            }
          },
        ));
  }
}
