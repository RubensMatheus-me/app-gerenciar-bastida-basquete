import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';

class AddTeam extends StatefulWidget {
  final Function refreshTeams;

  const AddTeam({super.key, required this.refreshTeams});

  @override
  _AddTeamState createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  final _formKey = GlobalKey<FormState>();
  String? _teamName;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var newTeam = DTOTeam(
        name: _teamName!,
      );

      ImpDaoTeam().insertTeam(newTeam).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Time criado com sucesso!')),
        );
        widget.refreshTeams();
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar time: $error')),
        );
      });
    }
  }

  Widget validateTeamName(Team team) {
    return TextFormField(
      validator: (value) => team.validTeamName(value ?? ''),
      onSaved: (newValue) => team.name = newValue ?? '',
      initialValue: team.name,
      decoration: const InputDecoration(labelText: 'Nome do time'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Time'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Crie um novo time',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome do Time',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do time';
                  }
                  return null;
                },
                onSaved: (value) {
                  _teamName = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: Text('Criar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
