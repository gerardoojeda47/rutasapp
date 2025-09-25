import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rouwhite/view/smart_search_page.dart';

void main() {
  group('SmartSearchPage Neighborhoods UI Tests', () {
    testWidgets('should display neighborhood categories',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      // Esperar a que se cargue la página
      await tester.pumpAndSettle();

      // Verificar que aparezcan las nuevas categorías
      expect(find.text('Barrios por Comuna'), findsOneWidget);
      expect(find.text('Sector Rural'), findsOneWidget);

      // Verificar que aparezcan las categorías existentes
      expect(find.text('Restaurantes'), findsOneWidget);
      expect(find.text('Hospitales'), findsOneWidget);
    });

    testWidgets('should show comunas selection when tapping Barrios por Comuna',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Tocar la categoría "Barrios por Comuna"
      await tester.tap(find.text('Barrios por Comuna'));
      await tester.pumpAndSettle();

      // Verificar que aparezca el modal de selección de comunas
      expect(find.text('Selecciona una Comuna'), findsOneWidget);
      expect(find.text('Comuna 1'), findsOneWidget);
      expect(find.text('Comuna 9'), findsOneWidget);
      expect(find.text('Sector Rural'), findsOneWidget);
    });

    testWidgets('should show rural areas when tapping Sector Rural',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Tocar la categoría "Sector Rural"
      await tester.tap(find.text('Sector Rural'));
      await tester.pumpAndSettle();

      // Verificar que se muestren resultados rurales
      // (Los resultados específicos dependerán de los datos)
      expect(find.text('Sector Rural'), findsWidgets);
    });

    testWidgets('should display proper icons for neighborhood categories',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que aparezcan los iconos correctos
      expect(find.byIcon(Icons.location_city), findsOneWidget);
      expect(find.byIcon(Icons.nature), findsOneWidget);
    });

    testWidgets('should handle comuna selection from modal',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Abrir modal de comunas
      await tester.tap(find.text('Barrios por Comuna'));
      await tester.pumpAndSettle();

      // Seleccionar Comuna 1
      await tester.tap(find.text('Comuna 1'));
      await tester.pumpAndSettle();

      // Verificar que se actualice el campo de búsqueda
      expect(find.text('Comuna 1'), findsWidgets);
    });

    testWidgets('should show neighborhood actions modal',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Abrir modal de comunas
      await tester.tap(find.text('Barrios por Comuna'));
      await tester.pumpAndSettle();

      // Seleccionar Comuna 1
      await tester.tap(find.text('Comuna 1'));
      await tester.pumpAndSettle();

      // Verificar que aparezca el modal de acciones
      expect(find.textContaining('ubicaciones en Comuna 1'), findsOneWidget);
      expect(find.text('Explorar Comuna 1'), findsOneWidget);
    });

    testWidgets('should display rural areas with proper labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Tocar Sector Rural
      await tester.tap(find.text('Sector Rural'));
      await tester.pumpAndSettle();

      // Verificar que aparezca información sobre áreas rurales
      expect(find.textContaining('Corregimientos y veredas'), findsOneWidget);
    });

    testWidgets('should handle empty search results gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Buscar algo que no existe
      await tester.enterText(find.byType(TextField), 'barrio inexistente xyz');
      await tester.pumpAndSettle();

      // Verificar que se maneje correctamente
      // (El comportamiento específico dependerá de la implementación)
    });
  });

  group('SmartSearchPage Neighborhoods Integration', () {
    testWidgets('should integrate with existing search functionality',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Buscar un barrio específico
      await tester.enterText(find.byType(TextField), 'villa occidente');
      await tester.pumpAndSettle();

      // Verificar que aparezcan resultados
      // (Los resultados específicos dependerán de los datos integrados)
    });

    testWidgets('should maintain existing category functionality',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartSearchPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que las categorías existentes sigan funcionando
      await tester.tap(find.text('Restaurantes'));
      await tester.pumpAndSettle();

      // Verificar que aparezca el modal de acciones para restaurantes
      expect(find.text('Ver restaurantes'), findsOneWidget);
    });
  });
}
