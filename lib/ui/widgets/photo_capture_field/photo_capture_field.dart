import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_action_sheet/app_action_sheet.dart';
import 'package:care_senior_study/ui/widgets/photo_capture_field/camera_capture_screen.dart';

/// Campo reutilizável para capturar (via câmera ou arquivo) e mostrar a
/// prévia de uma foto. Guarda apenas o caminho do arquivo local — não faz
/// upload.
class PhotoCaptureField extends StatelessWidget {
  const PhotoCaptureField({
    super.key,
    required this.photoPath,
    required this.onPhotoChanged,
    this.label = 'Foto (opcional)',
  });

  final String? photoPath;
  final ValueChanged<String> onPhotoChanged;
  final String label;

  void _choosePhotoSource(BuildContext context) {
    AppActionSheet.show(
      context,
      items: [
        AppActionSheetItem(
          icon: Icons.camera_alt_outlined,
          label: 'Tirar foto',
          onTap: () => _openCamera(context),
        ),
        AppActionSheetItem(
          icon: Icons.folder_open_outlined,
          label: 'Escolher arquivo',
          onTap: _pickFromFiles,
        ),
      ],
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    final path = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
    );

    if (path != null) {
      onPhotoChanged(path);
    }
  }

  Future<void> _pickFromFiles() async {
    // TODO(usuário): no Flutter Web, `PlatformFile.path` normalmente vem nulo
    // (o arquivo só existe como bytes em memória, sem caminho local) — teste
    // no navegador/dispositivo real que você for usar e ajuste se precisar
    // guardar os bytes em vez do caminho.
    final result = await FilePicker.pickFiles(type: FileType.image);
    final path = result?.files.single.path;
    if (path != null) {
      onPhotoChanged(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        GestureDetector(
          onTap: () => _choosePhotoSource(context),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: AppColor.greyLight,
            // No Chrome/web, `XFile.path` do pacote `camera` é uma blob URL, não um
            // caminho de arquivo — por isso usamos NetworkImage nesse caso. Em
            // mobile é um caminho real de arquivo, por isso usamos FileImage.
            // TODO(usuário): testar em dispositivo real (Android/iOS) e no navegador
            // que você realmente vai usar — o carregamento de blob URL via
            // NetworkImage pode variar entre o renderer HTML e o CanvasKit do Flutter Web.
            backgroundImage: photoPath == null
                ? null
                : (kIsWeb
                          ? NetworkImage(photoPath!)
                          : FileImage(File(photoPath!)))
                      as ImageProvider,
            child: photoPath == null
                ? const Icon(
                    Icons.add_a_photo_outlined,
                    color: AppColor.primaryDark,
                  )
                : null,
          ),
        ),
        Text(
          photoPath == null ? label : 'Toque na foto para trocar',
          style: AppTextStyle.captionStyle,
        ).expanded(),
      ],
    );
  }
}
