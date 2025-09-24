import 'package:flutter_test/flutter_test.dart';
import '../../lib/data/popayan_places_data.dart';

void main() {
  group('PopayanPlacesDatabase Integration Tests', () {
    test('should include neighborhoods in search results', () {
      final results = PopayanPlacesDatabase.searchPlaces('maria occidente');

      expect(results.isNotEmpty, true);

      // Debe encontrar Villa Occidente
      final hasVillaOccidente = results
          .any((place) => place.name.toLowerCase().contains('villa occidente'));
      expect(hasVillaOccidente, true);
    });

    test('should search neighborhoods by partial name', () {
      final results = PopayanPlacesDatabase.searchPlaces('la paz');

      expect(results.isNotEmpty, true);

      // Debe encontrar el barrio La Paz
      final hasLaPaz =
          results.any((place) => place.name.toLowerCase() == 'la paz');
      expect(hasLaPaz, true);
    });

    test('should search neighborhoods by comuna', () {
      final results = PopayanPlacesDatabase.searchPlaces('comuna 1');

      expect(results.isNotEmpty, true);

      // Debe encontrar barrios de Comuna 1
      final hasComuna1Neighborhoods =
          results.any((place) => place.address.contains('Comuna 1'));
      expect(hasComuna1Neighborhoods, true);
    });

    test('should return neighborhoods when searching by category Barrio', () {
      final results = PopayanPlacesDatabase.getPlacesByCategory('Barrio');

      expect(results.isNotEmpty, true);
      expect(results.length, greaterThan(50)); // Esperamos muchos barrios

      // Todos deben ser barrios
      expect(results.every((place) => place.category == 'Barrio'), true);
    });

    test('should include neighborhood categories', () {
      final categories = PopayanPlacesDatabase.getCategories();

      expect(categories.contains('Barrio'), true);
      expect(categories.contains('Corregimiento'), true);
      expect(categories.contains('Vereda'), true);
    });

    test('should return neighborhoods by comuna', () {
      final comuna1Neighborhoods =
          PopayanPlacesDatabase.getNeighborhoodsByComuna('Comuna 1');

      expect(comuna1Neighborhoods.isNotEmpty, true);
      expect(
          comuna1Neighborhoods
              .every((place) => place.address.contains('Comuna 1')),
          true);
    });

    test('should return all comunas', () {
      final comunas = PopayanPlacesDatabase.getComunas();

      expect(comunas.length, 10); // 9 comunas + Sector Rural
      expect(comunas.contains('Comuna 1'), true);
      expect(comunas.contains('Comuna 9'), true);
      expect(comunas.contains('Sector Rural'), true);
    });

    test('should return rural areas', () {
      final ruralAreas = PopayanPlacesDatabase.getRuralAreas();

      expect(ruralAreas.isNotEmpty, true);
      expect(
          ruralAreas.every((place) => place.address.contains('Sector Rural')),
          true);

      // Debe incluir corregimientos y veredas
      final hasCorregimientos =
          ruralAreas.any((place) => place.category == 'Corregimiento');
      final hasVeredas = ruralAreas.any((place) => place.category == 'Vereda');
      expect(hasCorregimientos, true);
      expect(hasVeredas, true);
    });

    test('should include popular neighborhood searches', () {
      final popularSearches = PopayanPlacesDatabase.getPopularSearches();

      expect(popularSearches.contains('Villa Occidente'), true);
      expect(popularSearches.contains('La Paz'), true);
      expect(popularSearches.contains('Lomas de Granada'), true);
    });

    test('converted neighborhoods should have proper format', () {
      final results = PopayanPlacesDatabase.searchPlaces('villa occidente');
      final villaOccidente =
          results.firstWhere((place) => place.name == 'Villa Occidente');

      expect(villaOccidente.id, 'villa_occidente_c9');
      expect(villaOccidente.name, 'Villa Occidente');
      expect(villaOccidente.category, 'Barrio');
      expect(villaOccidente.address.contains('Comuna 9'), true);
      expect(villaOccidente.coordinates.latitude, isNotNull);
      expect(villaOccidente.coordinates.longitude, isNotNull);
      expect(villaOccidente.keywords.contains('maria occidente'), true);
    });

    test('should search rural areas by type', () {
      final corregimientoResults =
          PopayanPlacesDatabase.searchPlaces('julumito');

      expect(corregimientoResults.isNotEmpty, true);

      final hasJulumito = corregimientoResults
          .any((place) => place.name.toLowerCase().contains('julumito'));
      expect(hasJulumito, true);
    });

    test('should search veredas', () {
      final veredaResults = PopayanPlacesDatabase.searchPlaces('vereda');

      expect(veredaResults.isNotEmpty, true);

      // Debe encontrar veredas
      final hasVeredas =
          veredaResults.any((place) => place.category == 'Vereda');
      expect(hasVeredas, true);
    });
  });
}
