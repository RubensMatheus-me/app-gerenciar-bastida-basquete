import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_player.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:sqflite/sqflite.dart';

class AddPlayer extends StatefulWidget {
  const AddPlayer({super.key});

  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  final _formKey = GlobalKey<FormState>();
  final Player _player = Player(); 

  int? _teamId;
  List<DTOTeam> _teams = [];

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    var teams = await ImpDaoTeam().getAllTeams();
    setState(() {
      _teams = teams;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var newPlayer = DTOPlayer(
        name: _player.name!,
        position: _player.position!,
        tShirtNumber: _player.tShirtNumber!,
        teamId: _teamId!,
        assists: 0,
        rebounds: 0,
      );

      ImpDaoPlayer().insertPlayer(newPlayer).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jogador adicionado com sucesso!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar jogador: $error')),
        );
      });
    }
  }

  Widget validatePlayerName() {
    return TextFormField(
      validator: _player.validatePlayerName,
      onSaved: (newValue) => _player.name = newValue!,
      initialValue: _player.name,
      decoration: const InputDecoration(labelText: 'Nome do jogador'),
    );
  }

  Widget validatePlayerPosition() {
    return TextFormField(
      validator: _player.validatePlayerPosition,
      onSaved: (newValue) => _player.position = newValue!,
      initialValue: _player.position,
      decoration: const InputDecoration(labelText: 'Posição do jogador'),
    );
  }

  Widget validateTshirtNumberPlayer() {
    return TextFormField(
      validator: (value) {
        final number = int.tryParse(value ?? '');
        return _player.validateTshirtNumberPlayer(number);
      },
      onSaved: (newValue) =>
          _player.tShirtNumber = int.tryParse(newValue ?? '')!,
      initialValue: _player.tShirtNumber?.toString() ?? '',
      decoration: const InputDecoration(labelText: 'Número da Camisa'),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Jogador'),
      ),
      body: _teams.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    validatePlayerName(),
                    validatePlayerPosition(),
                    validateTshirtNumberPlayer(),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Time'),
                      items: _teams.map((team) {
                        return DropdownMenuItem<int>(
                          value: team.id,
                          child: Text(team.name),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um time';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _teamId = value;
                        });
                      },
                      value: _teamId,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Adicionar Jogador'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
