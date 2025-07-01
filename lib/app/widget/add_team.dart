import 'package:datahoops/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:datahoops/app/domain/dto/dto_team.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datahoops/app/domain/entities/team.dart';

class AddTeam extends StatefulWidget {
  final TeamDto? teamToEdit;
  const AddTeam({super.key, this.teamToEdit});

  @override
  State<AddTeam> createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final Color accentColor = const Color(0xFFEF6C00);

  @override
void initState() {
  super.initState();
  if (widget.teamToEdit != null) {
    _nameController.text = widget.teamToEdit!.name;
  }
}

  void _saveTeam() async {
    if (_formKey.currentState!.validate()) {
      try {
        final teamName = _nameController.text.trim();

        final team = Team(id: widget.teamToEdit?.id, name: teamName);
        final teamDto = TeamDto.fromEntity(team);
        final dao = ImpDaoTeam();

        if (widget.teamToEdit == null) {
          await dao.insert(teamDto);
        } else {
          await dao.update(teamDto);
        }

        Navigator.pop(context, true); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar time: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins();

    return Scaffold(
  appBar: AppBar(
    title: Text('Novo Time', style: GoogleFonts.poppins(color: Colors.white)),
    backgroundColor: Colors.black87,
    foregroundColor: Colors.white,
    elevation: 1,
    centerTitle: true,
  ),
  backgroundColor: Colors.grey[900],
  body: Stack(
    children: [
      Positioned(
        bottom: -40,
        right: -40,
        child: Icon(
          Icons.sports_basketball,
          size: 240,
          color: accentColor.withAlpha((255 * 0.05).toInt()),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.sports_basketball, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    'Cadastrar um time',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Time',
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.95)),
                  prefixIcon: const Icon(Icons.group, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O nome do time não pode ser vazio.';
                  }
                  if (value.trim().length < 2) {
                    return 'O nome do time deve ter pelo menos 2 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _saveTeam,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Time'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);
  }
  }