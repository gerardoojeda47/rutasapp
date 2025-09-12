import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../data/popayan_places_data.dart';
import '../data/popayan_bus_routes.dart';
import '../core/utils/icon_helper.dart';
import '../core/services/bus_tracking_service.dart';
import 'navegacion_detallada_pagina.dart';

class SmartSearchPage extends StatefulWidget {
  const SmartSearchPage({super.key});

  @override
  State<SmartSearchPage> createState() => _SmartSearchPageState();
}

class _SmartSearchPageState extends State<SmartSearchPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Position? _currentPosition;
  bool _isLoadingLocation = true;
  bool _locationPermissionGranted = false;

  List<PopayanPlace> _searchResults = [];
  List<String> _suggestions = [];
  bool _isSearching = false;
  bool _showSuggestions = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _getCurrentLocation();
    _loadInitialSuggestions();

    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _currentPosition = position;
          _locationPermissionGranted = true;
          _isLoadingLocation = false;
        });
      } else {
        setState(() {
          _locationPermissionGranted = false;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _locationPermissionGranted = false;
        _isLoadingLocation = false;
      });
    }
  }

  void _loadInitialSuggestions() {
    setState(() {
      _suggestions = PopayanPlacesDatabase.getPopularSearches();
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text;

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _suggestions = PopayanPlacesDatabase.getPopularSearches();
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simular delay de búsqueda para efecto más realista
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_searchController.text == query) {
        final results = PopayanPlacesDatabase.searchPlaces(query);
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _searchFocusNode.hasFocus;
    });
  }

  void _selectPlace(PopayanPlace place) {
    if (!_locationPermissionGranted || _currentPosition == null) {
      _showLocationRequiredDialog();
      return;
    }

    final origin =
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NavegacionDetalladaPagina(
          origen: origin,
          destino: place.coordinates,
          nombreOrigen: 'Mi ubicación',
          nombreDestino: place.name,
        ),
      ),
    );
  }

  void _selectSuggestion(String suggestion) {
    _searchController.text = suggestion;
    _searchFocusNode.unfocus();
    _onSearchChanged();
  }

  /// Búsqueda directa por categoría desde los iconos (plurales → singulares)
  void _searchByCategory(String categoryPlural) {
    final Map<String, String> pluralToSingular = {
      'Restaurantes': 'Restaurante',
      'Hospitales': 'Hospital',
      'Bancos': 'Banco',
      'Hoteles': 'Hotel',
      'Supermercados': 'Supermercado',
      'Universidades': 'Universidad',
    };

    final String? singular = pluralToSingular[categoryPlural];
    if (singular == null) {
      _searchController.text = categoryPlural;
      _onSearchChanged();
      return;
    }

    setState(() {
      _searchController.text = categoryPlural;
      _isSearching = false;
      _showSuggestions = false;
      _searchResults = PopayanPlacesDatabase.getPlacesByCategory(singular);
    });

    // Ofrecer acciones rápidas para esa categoría
    _showCategoryActions(categoryPlural, singular);
  }

  void _showCategoryActions(String categoryPlural, String categorySingular) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(IconHelper.search),
                title: Text('Ver ${categoryPlural.toLowerCase()}'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(IconHelper.navigation),
                title: Text('Ir al ${categorySingular.toLowerCase()} más cercano'),
                onTap: () {
                  Navigator.pop(context);
                  _openNearestPlaceForCategory(categorySingular);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openNearestPlaceForCategory(String categorySingular) {
    if (!_locationPermissionGranted || _currentPosition == null) {
      _showLocationRequiredDialog();
      return;
    }

    final places = PopayanPlacesDatabase.getPlacesByCategory(categorySingular);
    if (places.isEmpty) return;

    final origin =
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    // Encontrar el lugar más cercano
    double bestDistance = double.infinity;
    PopayanPlace? bestPlace;
    for (final place in places) {
      final dx = origin.latitude - place.coordinates.latitude;
      final dy = origin.longitude - place.coordinates.longitude;
      final d2 = dx * dx + dy * dy; // distancia aproximada suficiente para elegir
      if (d2 < bestDistance) {
        bestDistance = d2;
        bestPlace = place;
      }
    }

    if (bestPlace != null) {
      _selectPlace(bestPlace);
    }
  }

  void _showLocationRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubicación Requerida'),
        content: const Text(
          'Para usar la navegación, necesitamos acceso a tu ubicación. '
          'Por favor, activa el GPS y concede los permisos necesarios.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _getCurrentLocation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6A00),
            ),
            child: const Text('Activar Ubicación'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Navegación Inteligente',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildLocationStatus(),
              _buildSearchSection(),
              Expanded(
                child: _buildResultsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6A00),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _locationPermissionGranted
                      ? IconHelper.locationOn
                      : IconHelper.locationOff,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isLoadingLocation
                          ? 'Obteniendo ubicación...'
                          : _locationPermissionGranted
                              ? 'Ubicación activada'
                              : 'Ubicación desactivada',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isLoadingLocation
                          ? 'Esperando GPS...'
                          : _locationPermissionGranted
                              ? 'Listo para navegar en Popayán'
                              : 'Toca para activar ubicación',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoadingLocation)
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: const LinearProgressIndicator(
                backgroundColor: Colors.white30,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Icon(
                  IconHelper.search,
                  color: Colors.grey[600],
                  size: 24,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: '¿A dónde quieres ir en Popayán?',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_isSearching)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFFF6A00)),
                    ),
                  )
                else if (_searchController.text.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                    },
                    icon: Icon(
                      IconHelper.clear,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),

          // Sugerencias rápidas
          if (_showSuggestions && _suggestions.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Búsquedas populares',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _suggestions.take(6).map((suggestion) {
                      return GestureDetector(
                        onTap: () => _selectSuggestion(suggestion),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFF6A00).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xFFFF6A00)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            suggestion,
                            style: const TextStyle(
                              color: Color(0xFFFF6A00),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_searchController.text.isEmpty) {
      return _buildCategoriesGrid();
    }

    if (_searchResults.isEmpty && !_isSearching) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      {
        'name': 'Restaurantes',
        'icon': IconHelper.restaurant,
        'color': Colors.orange
      },
      {'name': 'Hospitales', 'icon': IconHelper.hospital, 'color': Colors.red},
      {'name': 'Bancos', 'icon': IconHelper.bank, 'color': Colors.blue},
      {'name': 'Hoteles', 'icon': IconHelper.hotel, 'color': Colors.purple},
      {
        'name': 'Supermercados',
        'icon': IconHelper.supermarket,
        'color': Colors.green
      },
      {'name': 'Universidades', 'icon': IconHelper.university, 'color': Colors.indigo},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explora Popayán',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    _searchByCategory(category['name'] as String);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: (category['color'] as Color)
                                .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            size: 30,
                            color: category['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          category['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final place = _searchResults[index];
        final nearbyRoutes =
            PopayanBusRoutes.findNearbyRoutes(place.coordinates, 2.0);
        final busArrivals = BusTrackingService.getBusArrivals(place.coordinates);
        final routeInfos = BusTrackingService.getRoutesToDestination(place.coordinates);
        final trafficInfo = BusTrackingService.getTrafficInfo();

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(15),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6A00).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(place.category),
                    color: const Color(0xFFFF6A00),
                    size: 24,
                  ),
                ),
                title: Text(
                  place.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      place.address,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            place.category,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (place.rating > 0) ...[
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                place.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6A00),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    IconHelper.navigation,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onTap: () => _selectPlace(place),
              ),

              // Información de tráfico en tiempo real
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: Row(
                  children: [
                    Icon(
                      IconHelper.traffic,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tráfico: ${trafficInfo.levelText}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      trafficInfo.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Información de buses en tiempo real
              if (busArrivals.isNotEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey[200],
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      Row(
                        children: [
                          Icon(
                            IconHelper.bus,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Buses en tiempo real:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...busArrivals.take(3).map((arrival) => _buildBusArrivalCard(arrival)),
                    ],
                  ),
                ),

              // Información de rutas disponibles
              if (routeInfos.isNotEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey[200],
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      Row(
                        children: [
                          Icon(
                            IconHelper.route,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Rutas disponibles:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...routeInfos.take(3).map((routeInfo) => _buildRouteInfoCard(routeInfo)),
                    ],
                  ),
                ),

              // Información de rutas de bus cercanas (legacy)
              if (nearbyRoutes.isNotEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey[200],
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                        Row(
                          children: [
                            Icon(
                              IconHelper.bus,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          const SizedBox(width: 6),
                          Text(
                            'Rutas de bus cercanas:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: nearbyRoutes.take(3).map((route) {
                          final distance =
                              PopayanBusRoutes.getDistanceToNearestStop(
                                  route, place.coordinates);
                          final distanceText = distance < 1000
                              ? '${distance.round()}m'
                              : '${(distance / 1000).toStringAsFixed(1)}km';

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF4CAF50)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      route.name.split(' ').last,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${route.name} • $distanceText',
                                  style: const TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      if (nearbyRoutes.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '+${nearbyRoutes.length - 3} rutas más',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconHelper.search,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No encontramos resultados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Intenta con otro término de búsqueda',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'restaurante':
        return IconHelper.restaurant;
      case 'hospital':
        return IconHelper.hospital;
      case 'banco':
        return IconHelper.bank;
      case 'hotel':
        return IconHelper.hotel;
      case 'supermercado':
        return IconHelper.supermarket;
      case 'universidad':
        return IconHelper.university;
      case 'centro comercial':
        return IconHelper.shopping;
      case 'sitio turístico':
        return IconHelper.place;
      case 'iglesia':
        return IconHelper.church;
      case 'terminal':
        return IconHelper.terminal;
      case 'aeropuerto':
        return IconHelper.airport;
      case 'parque':
        return IconHelper.park;
      case 'farmacia':
        return IconHelper.pharmacy;
      case 'barrio':
        return IconHelper.neighborhood;
      default:
        return IconHelper.place;
    }
  }

  /// Construye la tarjeta de información de llegada de bus
  Widget _buildBusArrivalCard(BusArrivalInfo arrival) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: arrival.isTranspubenza 
            ? const Color(0xFF2196F3).withValues(alpha: 0.1)
            : const Color(0xFF4CAF50).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: arrival.isTranspubenza 
              ? const Color(0xFF2196F3).withValues(alpha: 0.3)
              : const Color(0xFF4CAF50).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: arrival.isTranspubenza 
                  ? const Color(0xFF2196F3)
                  : const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                arrival.busNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      arrival.routeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (arrival.isTranspubenza) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'TRANSPUBENZA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  arrival.arrivalText,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${arrival.nextStop} • ${arrival.occupancyText}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${arrival.currentPassengers}/${arrival.maxCapacity}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                arrival.status,
                style: TextStyle(
                  color: arrival.status == 'Retrasado' 
                      ? Colors.red 
                      : Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye la tarjeta de información de ruta
  Widget _buildRouteInfoCard(RouteInfo routeInfo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: routeInfo.isTranspubenza 
            ? const Color(0xFF2196F3).withValues(alpha: 0.1)
            : const Color(0xFF4CAF50).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: routeInfo.isTranspubenza 
              ? const Color(0xFF2196F3).withValues(alpha: 0.3)
              : const Color(0xFF4CAF50).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: routeInfo.isTranspubenza 
                  ? const Color(0xFF2196F3)
                  : const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                routeInfo.routeNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      routeInfo.routeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (routeInfo.isTranspubenza) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'TRANSPUBENZA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(IconHelper.time, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${routeInfo.durationText} • ${routeInfo.frequency}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(IconHelper.money, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${routeInfo.fare} • ${routeInfo.distanceText}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                routeInfo.nextBus,
                style: const TextStyle(
                  color: Color(0xFFFF6A00),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${routeInfo.stops} paradas',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
