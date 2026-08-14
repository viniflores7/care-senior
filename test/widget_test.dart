import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:care_senior_study/main.dart';

void main() {
  testWidgets('Exibe a tela de seleção de papel ao abrir o app', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CareSeniorApp());
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('Sou responsável/familiar'), findsOneWidget);
    expect(find.text('Sou da equipe da clínica'), findsOneWidget);
  });
}
