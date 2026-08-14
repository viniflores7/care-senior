import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';

class AppActionSheetItem {
  const AppActionSheetItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// Action sheet com fundo escuro e texto claro, coerente com a identidade
/// visual do app — usado no lugar do bottom sheet padrão do Material.
class AppActionSheet {
  AppActionSheet._();

  static Future<void> show(
    BuildContext context, {
    required List<AppActionSheetItem> items,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AppActionSheetView(items: items),
    );
  }
}

class _AppActionSheetView extends StatelessWidget {
  const _AppActionSheetView({required this.items});

  final List<AppActionSheetItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.primaryDark,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map(
                  (item) => ListTile(
                    leading: Icon(item.icon, color: AppColor.white),
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      item.onTap();
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
