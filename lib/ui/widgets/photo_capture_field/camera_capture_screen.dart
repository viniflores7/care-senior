import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';

/// Tela cheia de captura de foto usada pelo [PhotoCaptureField].
/// Retorna o caminho do arquivo capturado via `Navigator.pop(context, path)`,
/// ou `null` se o usuário cancelar.
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(
          () => _errorMessage = 'Nenhuma câmera disponível neste dispositivo.',
        );
        return;
      }

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );
      await controller.initialize();
      if (!mounted) return;

      setState(() => _controller = controller);
    } catch (e) {
      setState(() => _errorMessage = 'Não foi possível acessar a câmera: $e');
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null) return;

    final file = await controller.takePicture();
    if (!mounted) return;
    Navigator.of(context).pop(file.path);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.textDark,
      appBar: AppBar(
        backgroundColor: AppColor.textDark,
        foregroundColor: AppColor.white,
        title: const Text('Tirar foto'),
      ),
      body: _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColor.white),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : _controller == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.white),
            )
          : CameraPreview(_controller!),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _controller == null
          ? null
          : FloatingActionButton(
              onPressed: _capture,
              backgroundColor: AppColor.primary,
              child: const Icon(Icons.camera_alt, color: AppColor.white),
            ),
    );
  }
}
