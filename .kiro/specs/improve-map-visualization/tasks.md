# Implementation Plan

- [x] 1. Update MapaRutaPagina constructor and data source



  - Modify constructor to receive BusRoute object instead of just routeName and stops
  - Update rutas_pagina.dart to pass the complete BusRoute object to MapaRutaPagina
  - Remove hardcoded \_stopCoordinates map and use route.stops directly
  - Update \_setupRouteStops method to use real coordinates from BusRoute.stops
  - _Requirements: 1.1, 1.2, 1.3_




- [ ] 2. Create realistic route paths following Popayán streets

  - Define intermediate waypoints that follow major streets (Carrera 5, 6, 9, Calle 5)
  - Create route segments that connect stops via realistic street paths
  - Implement logic to generate waypoints between bus stops following actual roads
  - Ensure routes pass through appropriate neighborhoods and commercial areas
  - Add waypoints for center routes (via Parque Caldas, Carrera 5, Carrera 6)
  - Add waypoints for north routes (via Carrera 9, Vía al Norte)
  - Add waypoints for south routes (via Avenida Panamericana)
  - _Requirements: 1.4, 1.5, 2.2, 2.4, 2.5_



- [ ] 3. Implement route-specific colors

  - Create helper method to parse hex color strings from BusRoute.color
  - Update polyline color to use the specific route color
  - Update marker colors to match the route color scheme
  - Ensure color consistency across all map elements
  - _Requirements: 2.1, 2.3_


- [ ] 4. Fix deprecated API usage

  - Replace all withOpacity() calls with withValues(alpha:)
  - Update fitBounds() to use fitCamera(CameraFit.bounds())
  - Update any other deprecated flutter_map APIs
  - Test that all functionality works with updated APIs
  - _Requirements: 4.1, 4.2, 4.3, 4.4_

- [ ] 5. Improve automatic map fitting

  - Update \_fitBoundsToRoute method to use new CameraFit API
  - Implement better margin calculation for route bounds including waypoints
  - Ensure optimal zoom level for different route lengths
  - Add smooth animation when fitting bounds
  - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [ ] 6. Enhance stop information display

  - Update stop info modal to show neighborhood names from route.neighborhoods
  - Improve stop numbering and sequencing display
  - Add route-specific styling to stop information
  - Ensure stop names match the actual BusRoute data
  - _Requirements: 3.1, 3.2, 3.3, 3.4_

- [ ] 7. Test all 9 SOTRACAUCA routes with realistic paths
  - Verify each route displays with correct coordinates and realistic street paths
  - Test that each route shows its specific color
  - Verify stop information is accurate for all routes
  - Test map navigation and zoom functionality for all routes
  - Ensure routes look realistic and follow logical street patterns
  - Verify performance is good with detailed route paths
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 2.1, 2.2, 2.3, 2.4, 2.5, 3.1, 3.2, 3.3, 3.4, 5.1, 5.2, 5.3, 5.4_
