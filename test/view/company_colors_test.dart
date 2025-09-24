import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/view/smart_search_page.dart';

void main() {
  group('Company Colors Tests', () {
    testWidgets('should have different colors for each company',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Crear una instancia de la página para acceder a los métodos privados
      final smartSearchPageState =
          tester.state<_SmartSearchPageState>(find.byType(SmartSearchPage));

      // Verificar que cada empresa tiene un color único
      final sotracaucaColor =
          smartSearchPageState._getCompanyColor('SOTRACAUCA');
      final transpubenzaColor =
          smartSearchPageState._getCompanyColor('TRANSPUBENZA');
      final translibertadColor =
          smartSearchPageState._getCompanyColor('TRANSLIBERTAD');
      final transtamboColor =
          smartSearchPageState._getCompanyColor('TRANSTAMBO');

      // Verificar que todos los colores son diferentes
      expect(sotracaucaColor, isNot(equals(transpubenzaColor)));
      expect(sotracaucaColor, isNot(equals(translibertadColor)));
      expect(sotracaucaColor, isNot(equals(transtamboColor)));
      expect(transpubenzaColor, isNot(equals(translibertadColor)));
      expect(transpubenzaColor, isNot(equals(transtamboColor)));
      expect(translibertadColor, isNot(equals(transtamboColor)));

      // Verificar colores específicos
      expect(transpubenzaColor, const Color(0xFF2196F3)); // Azul
      expect(sotracaucaColor, const Color(0xFF4CAF50)); // Verde
      expect(translibertadColor, const Color(0xFFFF9800)); // Naranja
      expect(transtamboColor, const Color(0xFF9C27B0)); // Morado

      print('Colores de empresas:');
      print('SOTRACAUCA: ${sotracaucaColor.toString()}');
      print('TRANSPUBENZA: ${transpubenzaColor.toString()}');
      print('TRANSLIBERTAD: ${translibertadColor.toString()}');
      print('TRANSTAMBO: ${transtamboColor.toString()}');
    });

    testWidgets('should return company names correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      final smartSearchPageState =
          tester.state<_SmartSearchPageState>(find.byType(SmartSearchPage));

      // Verificar que los nombres se devuelven correctamente
      expect(smartSearchPageState._getCompanyDisplayName('SOTRACAUCA'),
          'SOTRACAUCA');
      expect(smartSearchPageState._getCompanyDisplayName('TRANSPUBENZA'),
          'TRANSPUBENZA');
      expect(smartSearchPageState._getCompanyDisplayName('TRANSLIBERTAD'),
          'TRANSLIBERTAD');
      expect(smartSearchPageState._getCompanyDisplayName('TRANSTAMBO'),
          'TRANSTAMBO');
    });

    testWidgets('should handle unknown company with default color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      final smartSearchPageState =
          tester.state<_SmartSearchPageState>(find.byType(SmartSearchPage));

      // Verificar que una empresa desconocida obtiene el color por defecto
      final unknownColor =
          smartSearchPageState._getCompanyColor('EMPRESA_DESCONOCIDA');
      expect(unknownColor, const Color(0xFF607D8B)); // Gris por defecto
    });
  });
}
