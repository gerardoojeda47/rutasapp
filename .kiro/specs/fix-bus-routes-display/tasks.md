# Implementation Plan

- [x] 1. Fix property access syntax in RutasPagina



  - Replace all Map-style property access (`ruta['property']`) with class property access (`ruta.property`)
  - Update name access from `ruta['nombre']` to `ruta.name`
  - Update company access from `ruta['empresa']` to `ruta.company`
  - Update schedule access from `ruta['horario']` to `ruta.schedule`
  - Update fare access from `ruta['costo']` to `ruta.fare`
  - _Requirements: 1.2, 1.3, 1.4, 1.5, 1.6, 4.1_



- [ ] 2. Handle missing fields with default values

  - Create helper methods to provide default values for missing fields
  - Implement default traffic status as "moderado"
  - Implement default next bus time as "5 min"


  - Calculate trayecto field from neighborhoods list using join(' - ')
  - _Requirements: 1.1, 4.2_

- [ ] 3. Update neighborhoods/stops handling



  - Replace `ruta['paradas']` access with `ruta.neighborhoods`
  - Update UI display to use neighborhoods list correctly
  - Ensure horizontal scroll for neighborhoods works properly
  - _Requirements: 1.1, 4.1_

- [x] 4. Fix favorites functionality



  - Update favorite toggle to use correct BusRoute properties
  - Use `ruta.id` as unique identifier for favorites
  - Update favorite data structure to match BusRoute properties
  - Fix favorite removal logic to work with new data structure



  - _Requirements: 2.1, 2.2, 2.3_

- [ ] 5. Update navigation parameters

  - Fix MapaRutaPagina navigation to use `ruta.name` instead of `ruta['nombre']`
  - Pass `ruta.neighborhoods` instead of `ruta['paradas']` to MapaRutaPagina
  - Update rastrear functionality to work with BusRoute properties
  - _Requirements: 3.1, 3.2, 3.3_

- [ ] 6. Test and verify functionality
  - Verify that all SOTRACAUCA routes display correctly
  - Test that route information shows proper data (name, company, schedule, fare)
  - Test favorites functionality (add/remove favorites)
  - Test navigation to map page works correctly
  - Test rastrear functionality works
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3_
