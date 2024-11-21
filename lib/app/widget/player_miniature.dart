import 'package:flutter/material.dart';

class PlayerMiniature extends StatelessWidget {
  final String name;
  final bool isSelected;

  const PlayerMiniature({Key? key, required this.name, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: Colors.yellow, width: 3) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person, size: 50),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
