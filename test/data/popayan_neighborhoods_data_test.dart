import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/data/popayan_neighborhoods_data.dart';

void main() {
  group('PopayanNeighborhoodsDatabase Tests', () {
    test('should return all neighborhoods', () {
      final neighborhoods = PopayanNeighborhoodsDatabase.getAllNeighborhoods();

      expect(neighborhoods.isNotEmpty, true);
      expect(neighborhoods.length,
          greaterThan(100)); // Esperamos más de 100 barrios
    });

    test('should return neighborhoods by comuna', () {
      final comuna1Neighborhoods =
          PopayanNeighborhoodsDatabase.getNeighborhoodsByComuna('Comuna 1');

      expect(comuna1Neighborhoods.isNotEmpty, true);
      expect(comuna1Neighborhoods.every((n) => n.comuna == 'Comuna 1'), true);

      // Verificar que incluye barrios específicos de Comuna 1
      final neighborhoodNames =
          comuna1Neighborhoods.map((n) => n.name).toList();
      expect(neighborhoodNames.contains('Modelo'), true);
      expect(neighborhoodNames.contains('La Esmeralda'), true);
      expect(neighborhoodNames.contains('Los Alpes'), true);
    });

    test('should return rural areas', () {
      final ruralAreas = PopayanNeighborhoodsDatabase.getRuralAreas();

      expect(ruralAreas.isNotEmpty, true);
      expect(ruralAreas.every((n) => n.comuna == 'Sector Rural'), true);

      // Verificar que incluye corregimientos y veredas
      final hasCorregimientos =
          ruralAreas.any((n) => n.type == 'Corregimiento');
      final hasVeredas = ruralAreas.any((n) => n.type == 'Vereda');
      expect(hasCorregimientos, true);
      expect(hasVeredas, true);
    });

    test('should search neighborhoods by name', () {
      final results = PopayanNeighborhoodsDatabase.searchNeighborhoods('maria');

      expect(results.isNotEmpty, true);

      // Debe encontrar "La Maria" y "Villa Occidente" (que tiene "maria occidente" en keywords)
      final names = results.map((n) => n.name.toLowerCase()).toList();
      expect(names.any((name) => name.contains('maria')), true);
    });

    test('should search neighborhoods by keywords', () {
      final results =
          PopayanNeighborhoodsDatabase.searchNeighborhoods('occidente');

      expect(results.isNotEmpty, true);

      // Debe encontrar Villa Occidente
      final hasVillaOccidente = results.any((n) => n.name == 'Villa Occidente');
      expect(hasVillaOccidente, true);
    });

    test('should return empty list for empty search query', () {
      final results = PopayanNeighborhoodsDatabase.searchNeighborhoods('');

      expect(results.isEmpty, true);
    });

    test('should return all comunas', () {
      final comunas = PopayanNeighborhoodsDatabase.getComunas();

      expect(comunas.length, 10); // 9 comunas + Sector Rural
      expect(comunas.contains('Comuna 1'), true);
      expect(comunas.contains('Comuna 9'), true);
      expect(comunas.contains('Sector Rural'), true);
    });

    test('should return neighborhoods by type', () {
      final barrios =
          PopayanNeighborhoodsDatabase.getNeighborhoodsByType('Barrio');
      final corregimientos =
          PopayanNeighborhoodsDatabase.getNeighborhoodsByType('Corregimiento');
      final veredas =
          PopayanNeighborhoodsDatabase.getNeighborhoodsByType('Vereda');

      expect(barrios.isNotEmpty, true);
      expect(corregimientos.isNotEmpty, true);
      expect(veredas.isNotEmpty, true);

      expect(barrios.every((n) => n.type == 'Barrio'), true);
      expect(corregimientos.every((n) => n.type == 'Corregimiento'), true);
      expect(veredas.every((n) => n.type == 'Vereda'), true);
    });

    test('should have valid coordinates for all neighborhoods', () {
      final neighborhoods = PopayanNeighborhoodsDatabase.getAllNeighborhoods();

      for (final neighborhood in neighborhoods) {
        expect(neighborhood.coordinates.latitude, isNotNull);
        expect(neighborhood.coordinates.longitude, isNotNull);

        // Verificar que las coordenadas están en el rango aproximado de Popayán
        expect(neighborhood.coordinates.latitude, greaterThan(2.0));
        expect(neighborhood.coordinates.latitude, lessThan(3.0));
        expect(neighborhood.coordinates.longitude, greaterThan(-77.0));
        expect(neighborhood.coordinates.longitude, lessThan(-76.0));
      }
    });

    test('should not have duplicate neighborhood IDs', () {
      final neighborhoods = PopayanNeighborhoodsDatabase.getAllNeighborhoods();
      final ids = neighborhoods.map((n) => n.id).toList();
      final uniqueIds = ids.toSet();

      expect(ids.length, uniqueIds.length);
    });

    test('should include all required neighborhoods from official list', () {
      final neighborhoods = PopayanNeighborhoodsDatabase.getAllNeighborhoods();
      final names = neighborhoods.map((n) => n.name).toList();

      // Verificar algunos barrios específicos del listado oficial
      expect(names.contains('Villa Occidente'), true);
      expect(names.contains('La Maria'), true);
      expect(names.contains('Lomas de Granada'), true);
      expect(names.contains('Chirimía'), true);
      expect(names.contains('La Paz'), true);
      expect(names.contains('Centro'), true);

      // Verificar corregimientos
      expect(names.contains('Julumito'), true);
      expect(names.contains('La Yunga'), true);
      expect(names.contains('Los Cerillos'), true);

      // Verificar veredas
      expect(names.contains('Vereda Julumito'), true);
      expect(names.contains('Vereda La Yunga'), true);
    });
  });

  group('PopayanNeighborhood Model Tests', () {
    test('should create neighborhood with all properties', () {
      final neighborhood = PopayanNeighborhood(
        id: 'test_id',
        name: 'Test Neighborhood',
        comuna: 'Comuna 1',
        coordinates: const LatLng(2.4448, -76.6147),
        type: 'Barrio',
        keywords: const ['test', 'neighborhood'],
        description: 'Test description',
      );

      expect(neighborhood.id, 'test_id');
      expect(neighborhood.name, 'Test Neighborhood');
      expect(neighborhood.comuna, 'Comuna 1');
      expect(neighborhood.type, 'Barrio');
      expect(neighborhood.keywords, ['test', 'neighborhood']);
      expect(neighborhood.description, 'Test description');
    });

    test('should create neighborhood without optional description', () {
      final neighborhood = PopayanNeighborhood(
        id: 'test_id',
        name: 'Test Neighborhood',
        comuna: 'Comuna 1',
        coordinates: const LatLng(2.4448, -76.6147),
        type: 'Barrio',
        keywords: const ['test', 'neighborhood'],
      );

      expect(neighborhood.description, null);
    });
  });
}
