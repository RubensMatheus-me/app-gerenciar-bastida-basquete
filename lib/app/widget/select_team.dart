import 'package:datahoops/app/database/sqlite/dao/imp_dao_match.dart';
import 'package:datahoops/app/database/sqlite/dao/imp_dao_player.dart';
import 'package:datahoops/app/domain/dto/dto_match.dart';
import 'package:datahoops/app/domain/enums/enum_match_type.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datahoops/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:datahoops/app/domain/dto/dto_team.dart';
import 'package:datahoops/app/domain/entities/match.dart' as app_match;
import 'package:datahoops/app/widget/play_match.dart';
import 'package:datahoops/routes.dart';

class SelectTeam extends StatefulWidget {
  const SelectTeam({super.key});

  @override
  State<SelectTeam> createState() => _SelectTeamState();
}

class _SelectTeamState extends State<SelectTeam> {
  List<TeamDto> _teams = [];
  MatchType _selectMatchType = MatchType.regularMatch;
  TeamDto? _teamA;
  TeamDto? _teamB;
  int? _selectedMaxPoints = 15;
  final List<int> _presetPoints = [11, 15, 21, 25, 30];

  final Color primaryColor = const Color(0xFFEF6C00);
  final Color backgroundColor = const Color(0xFF121212);

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final teams = await ImpDaoTeam().getAll();
    setState(() {
      _teams = teams;
      _isLoading = false;
      if (_teams.length >= 2) {
        _teamA = _teams[0];
        _teamB = _teams[1];
      }
    });
  }

  void _startMatch() async {
    if (_teamA == null || _teamB == null || _teamA!.id == _teamB!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione dois times diferentes')),
      );
      return;
    }

    final playerDao = ImpDaoPlayer();
    final teamDao = ImpDaoTeam();

    final allPlayersDto = await playerDao.findAll();
    final allTeamDto = await teamDao.getAll();

    final teams = allTeamDto.map((t) => t.toEntity()).toList();

    final players = allPlayersDto.map((pDto) {
      final team = teams.firstWhere((t) => t.id == pDto.teamId);

      return pDto.toEntity(team);
    }).toList();

    final teamAEntity = _teamA!.toEntity();
    final teamBEntity = _teamB!.toEntity();

    try {
      teamAEntity.validateMinimumPlayers(players);
      teamBEntity.validateMinimumPlayers(players);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString(), style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newMatch = app_match.Match( 
      id: null,
      timer: Duration.zero,
      maxPoints: _selectedMaxPoints ?? 15,
      winner: null,
      matchType: _selectMatchType,
    );

    final matchDto = MatchDto.fromEntity(newMatch);
    final daoMatch = ImpDaoMatch();
    final insertedId = await daoMatch.insert(matchDto);

    final matchWithIdDto = await daoMatch.getById(insertedId);
    final matchWithId = matchWithIdDto!.toEntity();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayMatch(
          teamA: _teamA!,
          teamB: _teamB!,
          match: matchWithId,
          matchType: _selectMatchType,
        ),
      ),
    );
  }

  String _getMatchTypeLabel(MatchType type) {
    switch (type) {
      case MatchType.regularMatch:
        return 'Partida Regular';
      case MatchType.professionalMatch:
        return 'Partida Profissional';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Selecionar Times',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 1,
        iconTheme: IconThemeData(color: primaryColor),
        foregroundColor: primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _teams.length < 2
          ? Center(
              child: Text(
                'Cadastre ao menos dois times para iniciar uma partida.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[400],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildTeamSelector(
                    title: 'Time A',
                    selected: _teamA,
                    borderColor: Colors.redAccent,
                    onChanged: (val) => setState(() => _teamA = val),
                  ),
                  const SizedBox(height: 32),
                  _buildTeamSelector(
                    title: 'Time B',
                    selected: _teamB,
                    borderColor: Colors.blueAccent,
                    onChanged: (val) => setState(() => _teamB = val),
                  ),
                  const SizedBox(height: 32),
                  _buildMatchTypeSelector(),
                  _buildMaxPointsSelector(),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: _startMatch,
                    icon: const Icon(Icons.play_arrow, size: 28),
                    label: Text(
                      'Iniciar Partida',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMaxPointsSelector() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    decoration: BoxDecoration(
      color: Colors.grey[900]?.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pontos da Partida',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedMaxPoints == null
              ? 'infinite'
              : _presetPoints.contains(_selectedMaxPoints)
                  ? _selectedMaxPoints.toString()
                  : 'custom',
          dropdownColor: Colors.grey[900],
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          items: [
            ..._presetPoints.map((p) =>
                DropdownMenuItem(value: p.toString(), child: Text('$p pontos'))),
            const DropdownMenuItem(value: 'infinite', child: Text('Infinito')),
            const DropdownMenuItem(value: 'custom', child: Text('Personalizado')),
          ],
          onChanged: (val) async {
            if (val == 'infinite') {
              setState(() => _selectedMaxPoints = null);
            } else if (val == 'custom') {
              final controller = TextEditingController();
              final result = await showDialog<int>(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    'Digite o limite de pontos',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ex: 40',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        final value = int.tryParse(controller.text);
                        Navigator.pop(context, value);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              if (result != null) {
                setState(() => _selectedMaxPoints = result);
              }
            } else {
              setState(() => _selectedMaxPoints = int.parse(val!));
            }
          },
        ),
        if (_selectedMaxPoints == null)
          const SizedBox(height: 8),
        if (_selectedMaxPoints == null)
          const Text(
            'Partida infinita — finalize manualmente',
            style: TextStyle(color: Colors.white70),
          ),
      ],
    ),
  );
}


  Widget _buildMatchTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tipo de Partida',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<MatchType>(
            value: _selectMatchType,
            dropdownColor: Colors.grey[850],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            iconEnabledColor: primaryColor,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            items: MatchType.values.map((type) {
              final label = _getMatchTypeLabel(type);
              return DropdownMenuItem(value: type, child: Text(label));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectMatchType = val);
              }
            },
          ),
        ],
      ),
    );
  }
  

  Widget _buildTeamSelector({
    required String title,
    required TeamDto? selected,
    required ValueChanged<TeamDto?> onChanged,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<TeamDto>(
            value: selected,
            dropdownColor: Colors.grey[850],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            iconEnabledColor: borderColor,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            items: _teams.map((team) {
              return DropdownMenuItem<TeamDto>(
                value: team,
                child: Text(team.name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
