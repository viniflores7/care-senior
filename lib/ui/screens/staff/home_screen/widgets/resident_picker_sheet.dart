import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_search_field/app_search_field.dart';

/// Folha pra escolher um idoso da clínica, com busca por nome — usada ao
/// cadastrar medicamento ou registrar um dado de saúde.
class ResidentPickerSheet extends StatefulWidget {
  const ResidentPickerSheet({super.key, required this.residents});

  final List<Resident> residents;

  @override
  State<ResidentPickerSheet> createState() => _ResidentPickerSheetState();
}

class _ResidentPickerSheetState extends State<ResidentPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? widget.residents
        : widget.residents
              .where((resident) => resident.name.toLowerCase().contains(query))
              .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSearchField(
              controller: _searchController,
              hint: 'Buscar idoso',
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Nenhum idoso encontrado.',
                        style: AppTextStyle.bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: filtered
                          .map(
                            (resident) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: AppAvatar(name: resident.name, radius: 18),
                              title: Text(resident.name),
                              subtitle: Text('Quarto ${resident.roomNumber}'),
                              onTap: () =>
                                  Navigator.of(context).pop(resident.id),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
