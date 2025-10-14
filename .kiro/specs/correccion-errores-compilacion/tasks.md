# Implementation Plan

- [x] 1. Corregir configuración de SDK y versiones críticas

  - Downgrade compileSdk y targetSdk de 36 a 34 en build.gradle.kts
  - Cambiar NDK version de 27.x a 25.1.8937393 para estabilidad
  - Actualizar Gradle wrapper a versión 8.3 estable
  - _Requirements: 1.1, 1.2, 4.1_

- [x] 2. Resolver conflictos de dependencias

  - [ ] 2.1 Actualizar dependency overrides en pubspec.yaml

    - Cambiar geolocator_android a versión 4.1.9
    - Downgrade flutter_map de 8.1.0 a 7.0.2

    - Agregar latlong2: 0.8.2 para compatibilidad
    - _Requirements: 3.1, 3.2_

  - [ ] 2.2 Limpiar y regenerar dependencias

    - Ejecutar flutter clean para limpiar cache
    - Ejecutar flutter pub get para reinstalar dependencias

    - Verificar árbol de dependencias con flutter pub deps
    - _Requirements: 3.3, 3.4_

- [ ] 3. Verificar y corregir configuración de keystore

  - [ ] 3.1 Validar archivos de firma existentes

    - Verificar existencia de android/key.jks
    - Comprobar configuración en android/key.properties
    - Validar credenciales de keystore
    - _Requirements: 2.1, 2.2_

  - [ ] 3.2 Regenerar keystore si es necesario
    - Crear nuevo keystore con keytool si el actual está corrupto
    - Actualizar key.properties con nuevas credenciales
    - Configurar signing config en build.gradle.kts
    - _Requirements: 2.3, 2.4_

- [ ] 4. Optimizar configuración de Gradle

  - [ ] 4.1 Actualizar configuraciones de compilación

    - Cambiar JavaVersion de VERSION_11 a VERSION_1_8
    - Configurar opciones de memoria para Gradle
    - Optimizar configuración de dexOptions
    - _Requirements: 4.1, 4.2_

  - [ ] 4.2 Limpiar cache y rebuilds
    - Ejecutar ./gradlew clean en directorio android
    - Eliminar carpetas .gradle y build
    - Regenerar wrapper de Gradle
    - _Requirements: 4.3, 4.4_

- [ ] 5. Validar configuración de Firebase

  - [ ] 5.1 Verificar google-services.json

    - Comprobar que el archivo esté en android/app/
    - Validar que package_name coincida con applicationId
    - Verificar configuración de Firebase plugins
    - _Requirements: 5.1, 5.2_

  - [ ] 5.2 Corregir dependencias de Firebase
    - Verificar versión de firebase_core en pubspec.yaml
    - Comprobar compatibilidad con otras dependencias
    - Actualizar google-services plugin si es necesario
    - _Requirements: 5.3, 5.4_


- [ ] 6. Ejecutar build de prueba y validación

  - [ ] 6.1 Probar build debug

    - Ejecutar flutter build apk --debug
    - Verificar que no hay errores de compilación



    - Validar que el APK se genera correctamente
    - _Requirements: 1.1, 6.1_

  - [ ] 6.2 Probar build release
    - Ejecutar flutter build apk --release
    - Verificar firma del APK generado
    - Probar instalación en dispositivo de prueba
    - _Requirements: 1.2, 2.3, 6.2_

- [ ] 7. Implementar validaciones automáticas

  - [ ] 7.1 Crear script de validación pre-build

    - Verificar configuración de dependencias
    - Validar archivos de keystore antes del build
    - Comprobar configuración de Firebase
    - _Requirements: 6.1, 6.3_

  - [ ] 7.2 Configurar checks de CI/CD
    - Actualizar GitHub Actions para usar configuraciones corregidas
    - Agregar validaciones de build en workflow
    - Configurar notificaciones de errores
    - _Requirements: 6.2, 6.4_

- [ ]\* 8. Testing y documentación

  - [ ]\* 8.1 Crear tests de validación de build

    - Escribir tests para verificar configuración de Gradle
    - Crear tests para validar dependencias
    - Implementar tests de integración para Firebase
    - _Requirements: 6.1, 6.2_

  - [ ]\* 8.2 Documentar soluciones y troubleshooting
    - Crear guía de troubleshooting para errores comunes
    - Documentar proceso de regeneración de keystore
    - Escribir procedimientos de validación de build
    - _Requirements: 6.3, 6.4_

- [ ] 9. Corregir errores de compatibilidad con flutter_map 7.0.2

  - [ ] 9.1 Remover declaraciones const de constructores LatLng

    - Quitar const de todas las instancias de LatLng en archivos de vista
    - Actualizar archivos de datos de barrios y rutas
    - Corregir archivos de configuración y servicios
    - _Requirements: 3.1, 3.2_

  - [ ] 9.2 Corregir parámetros obsoletos de TileLayer
    - Remover parámetro tileDimension que no existe en flutter_map 7.0.2
    - Actualizar configuración de capas de mapa
    - _Requirements: 3.1, 3.2_
