import 'package:datahoops/app/database/sqlite/dao/imp_dao_player.dart';
import 'package:datahoops/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:datahoops/app/domain/dto/dto_player.dart';
import 'package:datahoops/app/domain/dto/dto_team.dart';
import 'package:datahoops/app/domain/entities/player.dart';
import 'package:datahoops/app/domain/entities/position.dart';
import 'package:datahoops/app/domain/enums/enum_positions_type.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPlayer extends StatefulWidget {
  final PlayerDto? playerToEdit;
  const AddPlayer({super.key, this.playerToEdit});

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shirtNumberController = TextEditingController();

  PositionType? _selectedPosition;
  List<TeamDto> _teams = [];
  TeamDto? _selectedTeam;

  final Color accentColor = const Color(0xFFEF6C00);

  PositionType positionTypeFromString(String value) {
    try {
      return PositionType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      throw Exception("Posição inválida: '$value'. Não corresponde a nenhuma posição.");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTeams().then((_) {
      if (widget.playerToEdit != null) {
        final p = widget.playerToEdit!;
        _nameController.text = p.name;
        _shirtNumberController.text = p.shirtNumber.toString();
        _selectedPosition = positionTypeFromString(p.position);
        _selectedTeam = _teams.firstWhere((t) => t.id == p.teamId);
      }
    });
  }

  Future<void> _loadTeams() async {
    final teams = await ImpDaoTeam().getAll();
    setState(() {
      _teams = teams;
      if (_teams.isNotEmpty) _selectedTeam = _teams.first;
      _selectedPosition = PositionType.values.first;
    });
  }

  void _savePlayer() async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = _nameController.text.trim();
        final shirtNumber = int.parse(_shirtNumberController.text.trim());
        final position = _selectedPosition!;
        final team = _selectedTeam!.toEntity();

        final player = Player(
          id: widget.playerToEdit?.id,
          name: name,
          shirtNumber: shirtNumber,
          position: position,
          team: team,
        );
        final dao = ImpDaoPlayer();

        if (widget.playerToEdit == null) {
          final insertedId = await dao.insert(PlayerDto.fromEntity(player));
          Navigator.pop(
            context,
            {
              'player': Player(
                id: insertedId,
                name: name,
                shirtNumber: shirtNumber,
                position: position,
                team: team,
              ),
              'team': _selectedTeam,
            },
          );
        } else {
          await dao.update(PlayerDto.fromEntity(player));
          Navigator.pop(context, {'player': player, 'team': _selectedTeam});
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar jogador: ${e.toString()}')),
        );
      }
    }
  }

  String formatPositionName(PositionType pos) {
    switch (pos) {
      case PositionType.armador:
        return "Armador";
      case PositionType.alaArmador:
        return "Ala-Armador";
      case PositionType.ala:
        return "Ala";
      case PositionType.alaPivo:
        return "Ala-Pivô";
      case PositionType.pivo:
        return "Pivô";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Jogador', style: GoogleFonts.poppins()),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: accentColor),
        foregroundColor: accentColor,
        elevation: 1,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _teams.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum time cadastrado.\nCadastre um time primeiro.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Icon(Icons.sports_basketball, size: 100, color: accentColor),
                      const SizedBox(height: 24),

                      // Nome
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nome do Jogador',
                          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.95)),
                          prefixIcon: const Icon(Icons.person, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) => Player.validateName(value),
                      ),
                      const SizedBox(height: 16),

                      // Número
                      TextFormField(
                        controller: _shirtNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Número da Camisa',
                          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.95)),
                          prefixIcon: const Icon(Icons.numbers, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) => Player.validateShirtNumber(value),
                      ),
                      const SizedBox(height: 16),

                      // Posição
                      DropdownButtonFormField<PositionType>(
                        value: _selectedPosition,
                        decoration: InputDecoration(
                          labelText: 'Posição',
                          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.95)),
                          prefixIcon: const Icon(Icons.sports, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        dropdownColor: Colors.grey.shade800,
                        style: const TextStyle(color: Colors.white),
                        items: PositionType.values.map((pos) {
                          return DropdownMenuItem(
                            value: pos,
                            child: Text(formatPositionName(pos), style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (pos) => setState(() => _selectedPosition = pos),
                        validator: (value) => value == null ? 'Selecione uma posição.' : null,
                      ),
                      const SizedBox(height: 16),

                      // Time
                      DropdownButtonFormField<TeamDto>(
                        value: _selectedTeam,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.95)),
                          prefixIcon: const Icon(Icons.groups, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        dropdownColor: Colors.grey.shade800,
                        style: const TextStyle(color: Colors.white),
                        items: _teams.map((teamDto) {
                          return DropdownMenuItem(
                            value: teamDto,
                            child: Text(teamDto.name, style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (newTeamDto) => setState(() => _selectedTeam = newTeamDto),
                        validator: (value) => Player.validateTeam(value?.toEntity()),
                      ),
                      const SizedBox(height: 24),

                      // Botão Salvar
                      ElevatedButton.icon(
                        onPressed: _savePlayer,
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar Jogador'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
