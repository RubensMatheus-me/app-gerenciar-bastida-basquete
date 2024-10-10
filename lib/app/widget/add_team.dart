import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';

class AddTeam extends StatefulWidget {
  final Function refreshTeams;

  AddTeam({required this.refreshTeams});

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
          SnackBar(content: Text('Time criado com sucesso!')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Time'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crie um novo time',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm, 
                child: Text('Criar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
