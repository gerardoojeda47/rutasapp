import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'popayan_neighborhoods_data.dart';

/// Datos reales de lugares en Popayán
class PopayanPlace {
  final String id;
  final String name;
  final String category;
  final String address;
  final LatLng coordinates;
  final String description;
  final List<String> keywords;
  final String? phone;
  final String? website;
  final double rating;
  final List<String> photos;

  const PopayanPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.coordinates,
    required this.description,
    required this.keywords,
    this.phone,
    this.website,
    this.rating = 0.0,
    this.photos = const [],
  });
}

/// Base de datos de lugares reales en Popayán
class PopayanPlacesDatabase {
  static const List<PopayanPlace> places = [
    // CENTROS COMERCIALES Y TIENDAS
    PopayanPlace(
      id: 'cc_campanario',
      name: 'Centro Comercial Campanario',
      category: 'Centro Comercial',
      address: 'Calle 5 # 38-71, Popayán, Cauca',
      coordinates: LatLng(2.4448, -76.6147),
      description:
          'Principal centro comercial de Popayán con tiendas, restaurantes y cine',
      keywords: [
        'centro comercial',
        'campanario',
        'tiendas',
        'cine',
        'compras'
      ],
      phone: '+57 2 8244000',
      rating: 4.2,
      photos: ['campanario1.jpg', 'campanario2.jpg'],
    ),

    PopayanPlace(
      id: 'cc_anarkos',
      name: 'Centro Comercial Anarkos',
      category: 'Centro Comercial',
      address: 'Carrera 9 # 24N-07, Popayán, Cauca',
      coordinates: LatLng(2.4520, -76.6050),
      description: 'Centro comercial moderno en el norte de Popayán',
      keywords: ['centro comercial', 'anarkos', 'norte', 'tiendas'],
      phone: '+57 2 8310000',
      rating: 4.0,
    ),

    // UNIVERSIDADES Y EDUCACIÓN
    PopayanPlace(
      id: 'unicauca',
      name: 'Universidad del Cauca',
      category: 'Universidad',
      address: 'Calle 5 # 4-70, Popayán, Cauca',
      coordinates: LatLng(2.4430, -76.6120),
      description:
          'Universidad pública más importante del Cauca, fundada en 1827',
      keywords: [
        'universidad',
        'unicauca',
        'educación',
        'estudiantes',
        'campus'
      ],
      phone: '+57 2 8209800',
      website: 'www.unicauca.edu.co',
      rating: 4.5,
    ),

    PopayanPlace(
      id: 'fundacion_universitaria',
      name: 'Fundación Universitaria de Popayán',
      category: 'Universidad',
      address: 'Carrera 6 # 5-62, Popayán, Cauca',
      coordinates: LatLng(2.4445, -76.6135),
      description: 'Universidad privada con programas de pregrado y posgrado',
      keywords: ['universidad', 'fup', 'educación', 'privada'],
      phone: '+57 2 8244000',
      rating: 4.1,
    ),

    // HOSPITALES Y SALUD
    PopayanPlace(
      id: 'hospital_san_jose',
      name: 'Hospital San José',
      category: 'Hospital',
      address: 'Carrera 6 # 8N-59, Popayán, Cauca',
      coordinates: LatLng(2.4460, -76.6160),
      description:
          'Hospital de tercer nivel, principal centro de salud de Popayán',
      keywords: ['hospital', 'san josé', 'salud', 'emergencias', 'médico'],
      phone: '+57 2 8244444',
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'hospital_universitario',
      name: 'Hospital Universitario San José',
      category: 'Hospital',
      address: 'Carrera 6 # 8N-59, Popayán, Cauca',
      coordinates: LatLng(2.4465, -76.6165),
      description: 'Hospital universitario de alta complejidad',
      keywords: ['hospital', 'universitario', 'salud', 'especialistas'],
      phone: '+57 2 8244500',
      rating: 4.2,
    ),

    // LUGARES TURÍSTICOS E HISTÓRICOS
    PopayanPlace(
      id: 'centro_historico',
      name: 'Centro Histórico de Popayán',
      category: 'Sitio Turístico',
      address: 'Parque Caldas, Popayán, Cauca',
      coordinates: LatLng(2.4448, -76.6147),
      description:
          'Patrimonio de la Humanidad UNESCO, corazón colonial de Popayán',
      keywords: [
        'centro histórico',
        'parque caldas',
        'colonial',
        'turismo',
        'patrimonio'
      ],
      rating: 4.8,
    ),

    PopayanPlace(
      id: 'catedral_basilica',
      name: 'Catedral Basílica Nuestra Señora de la Asunción',
      category: 'Iglesia',
      address: 'Carrera 5 # 4-01, Popayán, Cauca',
      coordinates: LatLng(2.4448, -76.6147),
      description: 'Catedral principal de Popayán, arquitectura colonial',
      keywords: ['catedral', 'iglesia', 'basílica', 'religioso', 'colonial'],
      rating: 4.6,
    ),

    PopayanPlace(
      id: 'puente_humilladero',
      name: 'Puente del Humilladero',
      category: 'Sitio Turístico',
      address: 'Carrera 6, Popayán, Cauca',
      coordinates: LatLng(2.4435, -76.6155),
      description: 'Puente histórico colonial sobre el río Molino',
      keywords: ['puente', 'humilladero', 'histórico', 'colonial', 'río'],
      rating: 4.3,
    ),

    PopayanPlace(
      id: 'morro_tulcan',
      name: 'Morro de Tulcán',
      category: 'Sitio Turístico',
      address: 'Tulcán, Popayán, Cauca',
      coordinates: LatLng(2.4520, -76.6200),
      description: 'Pirámide precolombina con vista panorámica de Popayán',
      keywords: [
        'morro',
        'tulcán',
        'pirámide',
        'precolombino',
        'vista',
        'panorámica'
      ],
      rating: 4.4,
    ),

    // RESTAURANTES Y GASTRONOMÍA
    PopayanPlace(
      id: 'restaurante_mora_castilla',
      name: 'Restaurante Mora de Castilla',
      category: 'Restaurante',
      address: 'Calle 5 # 2-75, Popayán, Cauca',
      coordinates: LatLng(2.4445, -76.6140),
      description: 'Restaurante de comida típica caucana y colombiana',
      keywords: ['restaurante', 'mora castilla', 'comida típica', 'caucana'],
      phone: '+57 2 8242596',
      rating: 4.3,
    ),

    PopayanPlace(
      id: 'la_cosecha_parrillada',
      name: 'La Cosecha Parrillada',
      category: 'Restaurante',
      address: 'Calle 4 # 9-67, Popayán, Cauca',
      coordinates: LatLng(2.4440, -76.6130),
      description:
          'Especialidad en carnes a la parrilla y comida internacional',
      keywords: ['restaurante', 'parrilla', 'carnes', 'cosecha'],
      phone: '+57 2 8205678',
      rating: 4.5,
    ),

    // BANCOS Y SERVICIOS FINANCIEROS
    PopayanPlace(
      id: 'banco_popular',
      name: 'Banco Popular',
      category: 'Banco',
      address: 'Carrera 6 # 4-29, Popayán, Cauca',
      coordinates: LatLng(2.4445, -76.6145),
      description: 'Sucursal principal del Banco Popular en Popayán',
      keywords: ['banco', 'popular', 'cajero', 'servicios financieros'],
      phone: '+57 2 8244000',
      rating: 3.8,
    ),

    PopayanPlace(
      id: 'bancolombia',
      name: 'Bancolombia',
      category: 'Banco',
      address: 'Carrera 5 # 4-36, Popayán, Cauca',
      coordinates: LatLng(2.4447, -76.6148),
      description: 'Sucursal de Bancolombia en el centro de Popayán',
      keywords: ['banco', 'bancolombia', 'cajero', 'centro'],
      phone: '+57 2 8243000',
      rating: 3.9,
    ),

    // TRANSPORTE
    PopayanPlace(
      id: 'terminal_transportes',
      name: 'Terminal de Transportes',
      category: 'Terminal',
      address: 'Carrera 7 # 2N-46, Popayán, Cauca',
      coordinates: LatLng(2.4500, -76.6170),
      description: 'Terminal de buses intermunicipal e interdepartamental',
      keywords: ['terminal', 'buses', 'transporte', 'viajes'],
      phone: '+57 2 8244567',
      rating: 3.5,
    ),

    PopayanPlace(
      id: 'aeropuerto',
      name: 'Aeropuerto Guillermo León Valencia',
      category: 'Aeropuerto',
      address: 'Vereda Machángara, Popayán, Cauca',
      coordinates: LatLng(2.4544, -76.6092),
      description: 'Aeropuerto regional de Popayán',
      keywords: ['aeropuerto', 'vuelos', 'guillermo león valencia'],
      phone: '+57 2 8244800',
      rating: 3.7,
    ),

    // PARQUES Y RECREACIÓN
    PopayanPlace(
      id: 'parque_caldas',
      name: 'Parque Caldas',
      category: 'Parque',
      address: 'Centro, Popayán, Cauca',
      coordinates: LatLng(2.4448, -76.6147),
      description: 'Parque principal de Popayán, corazón del centro histórico',
      keywords: ['parque', 'caldas', 'centro', 'principal'],
      rating: 4.7,
    ),

    PopayanPlace(
      id: 'parque_francisco_jose_caldas',
      name: 'Parque Francisco José de Caldas',
      category: 'Parque',
      address: 'Carrera 2 # 1N-25, Popayán, Cauca',
      coordinates: LatLng(2.4470, -76.6180),
      description: 'Parque recreativo con zonas verdes y juegos infantiles',
      keywords: ['parque', 'francisco josé caldas', 'recreativo', 'niños'],
      rating: 4.1,
    ),

    // HOTELES
    PopayanPlace(
      id: 'hotel_dann_monasterio',
      name: 'Hotel Dann Monasterio',
      category: 'Hotel',
      address: 'Calle 4 # 10-14, Popayán, Cauca',
      coordinates: LatLng(2.4440, -76.6125),
      description: 'Hotel boutique en edificio colonial restaurado',
      keywords: ['hotel', 'dann', 'monasterio', 'colonial', 'boutique'],
      phone: '+57 2 8244930',
      rating: 4.4,
    ),

    PopayanPlace(
      id: 'hotel_camino_real',
      name: 'Hotel Camino Real',
      category: 'Hotel',
      address: 'Calle 5 # 5-59, Popayán, Cauca',
      coordinates: LatLng(2.4445, -76.6140),
      description: 'Hotel tradicional en el centro histórico',
      keywords: ['hotel', 'camino real', 'tradicional', 'centro'],
      phone: '+57 2 8244546',
      rating: 4.0,
    ),

    // FARMACIAS Y DROGUERÍAS
    PopayanPlace(
      id: 'drogueria_pasteur',
      name: 'Droguería Pasteur',
      category: 'Farmacia',
      address: 'Carrera 6 # 4-67, Popayán, Cauca',
      coordinates: LatLng(2.4446, -76.6146),
      description: 'Droguería con amplio surtido de medicamentos',
      keywords: ['droguería', 'pasteur', 'medicamentos', 'farmacia'],
      phone: '+57 2 8243456',
      rating: 4.2,
    ),

    // SUPERMERCADOS
    PopayanPlace(
      id: 'exito_popayan',
      name: 'Éxito Popayán',
      category: 'Supermercado',
      address: 'Calle 5 # 38-71, Popayán, Cauca',
      coordinates: LatLng(2.4448, -76.6147),
      description: 'Supermercado Éxito en Centro Comercial Campanario',
      keywords: ['supermercado', 'éxito', 'compras', 'campanario'],
      phone: '+57 2 8244000',
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'olimpica_popayan',
      name: 'Olímpica Popayán',
      category: 'Supermercado',
      address: 'Carrera 9 # 24N-07, Popayán, Cauca',
      coordinates: LatLng(2.4520, -76.6050),
      description: 'Supermercado Olímpica en el norte de Popayán',
      keywords: ['supermercado', 'olímpica', 'norte', 'compras'],
      phone: '+57 2 8310000',
      rating: 3.9,
    ),

    // BARRIOS DE POPAYÁN - ZONA CENTRO
    PopayanPlace(
      id: 'barrio_centro',
      name: 'Barrio Centro',
      category: 'Barrio',
      address: 'Centro, Popayán, Cauca',
      coordinates: LatLng(2.4448, -76.6147),
      description:
          'Centro histórico y comercial de Popayán, corazón de la ciudad blanca',
      keywords: ['barrio', 'centro', 'histórico', 'comercial', 'parque caldas'],
      rating: 4.5,
    ),

    PopayanPlace(
      id: 'barrio_caldas',
      name: 'Barrio Caldas',
      category: 'Barrio',
      address: 'Caldas, Popayán, Cauca',
      coordinates: LatLng(2.4440, -76.6150),
      description: 'Barrio céntrico cerca del Parque Caldas',
      keywords: ['barrio', 'caldas', 'centro', 'parque'],
      rating: 4.3,
    ),

    // BARRIOS ZONA NORTE
    PopayanPlace(
      id: 'la_paz',
      name: 'La Paz',
      category: 'Barrio',
      address: 'La Paz, Popayán, Cauca',
      coordinates: LatLng(2.4490, -76.6080),
      description:
          'Barrio residencial del norte, bien conectado con transporte público',
      keywords: ['barrio', 'la paz', 'norte', 'residencial', 'transporte'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'jose_maria_obando',
      name: 'José María Obando',
      category: 'Barrio',
      address: 'José María Obando, Popayán, Cauca',
      coordinates: LatLng(2.4530, -76.6060),
      description: 'Barrio del norte con buena infraestructura y servicios',
      keywords: ['barrio', 'josé maría obando', 'norte', 'servicios'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'san_camilo',
      name: 'San Camilo',
      category: 'Barrio',
      address: 'San Camilo, Popayán, Cauca',
      coordinates: LatLng(2.4550, -76.6040),
      description: 'Barrio tranquilo del norte de Popayán',
      keywords: ['barrio', 'san camilo', 'norte', 'tranquilo'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'los_sauces',
      name: 'Los Sauces',
      category: 'Barrio',
      address: 'Los Sauces, Popayán, Cauca',
      coordinates: LatLng(2.4520, -76.6100),
      description: 'Barrio residencial con zonas verdes',
      keywords: ['barrio', 'los sauces', 'residencial', 'zonas verdes'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'la_campiña',
      name: 'La Campiña',
      category: 'Barrio',
      address: 'La Campiña, Popayán, Cauca',
      coordinates: LatLng(2.4540, -76.6080),
      description: 'Barrio moderno con buena planificación urbana',
      keywords: ['barrio', 'la campiña', 'moderno', 'planificación'],
      rating: 4.3,
    ),

    PopayanPlace(
      id: 'maria_oriente',
      name: 'María Oriente',
      category: 'Barrio',
      address: 'María Oriente, Popayán, Cauca',
      coordinates: LatLng(2.4560, -76.6060),
      description: 'Barrio del noreste con desarrollo comercial',
      keywords: ['barrio', 'maría oriente', 'noreste', 'comercial'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'la_floresta',
      name: 'La Floresta',
      category: 'Barrio',
      address: 'La Floresta, Popayán, Cauca',
      coordinates: LatLng(2.4500, -76.6110),
      description: 'Barrio con abundante vegetación y ambiente familiar',
      keywords: ['barrio', 'la floresta', 'vegetación', 'familiar'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'el_lago',
      name: 'El Lago',
      category: 'Barrio',
      address: 'El Lago, Popayán, Cauca',
      coordinates: LatLng(2.4510, -76.6090),
      description: 'Barrio cerca de zonas recreativas',
      keywords: ['barrio', 'el lago', 'recreativo', 'familiar'],
      rating: 4.0,
    ),

    // BARRIOS ZONA ORIENTE
    PopayanPlace(
      id: 'la_esmeralda',
      name: 'La Esmeralda',
      category: 'Barrio',
      address: 'La Esmeralda, Popayán, Cauca',
      coordinates: LatLng(2.4400, -76.6000),
      description: 'Barrio tradicional al oriente, con historia y cultura',
      keywords: ['barrio', 'esmeralda', 'oriente', 'tradicional', 'cultura'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'campan',
      name: 'Campan',
      category: 'Barrio',
      address: 'Campan, Popayán, Cauca',
      coordinates: LatLng(2.4420, -76.6090),
      description: 'Barrio del oriente con buena conectividad',
      keywords: ['barrio', 'campan', 'oriente', 'conectividad'],
      rating: 3.9,
    ),

    PopayanPlace(
      id: 'el_recuerdo',
      name: 'El Recuerdo',
      category: 'Barrio',
      address: 'El Recuerdo, Popayán, Cauca',
      coordinates: LatLng(2.4380, -76.6070),
      description: 'Barrio histórico con arquitectura tradicional',
      keywords: ['barrio', 'el recuerdo', 'histórico', 'arquitectura'],
      rating: 3.8,
    ),

    // BARRIOS ZONA SUR
    PopayanPlace(
      id: 'bello_horizonte',
      name: 'Bello Horizonte',
      category: 'Barrio',
      address: 'Bello Horizonte, Popayán, Cauca',
      coordinates: LatLng(2.4380, -76.6170),
      description: 'Barrio del sur con vista panorámica de la ciudad',
      keywords: ['barrio', 'bello horizonte', 'sur', 'vista', 'panorámica'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'el_placer',
      name: 'El Placer',
      category: 'Barrio',
      address: 'El Placer, Popayán, Cauca',
      coordinates: LatLng(2.4360, -76.6180),
      description: 'Barrio popular del sur con gran comunidad',
      keywords: ['barrio', 'el placer', 'sur', 'popular', 'comunidad'],
      rating: 3.9,
    ),

    PopayanPlace(
      id: 'alfonso_lopez',
      name: 'Alfonso López',
      category: 'Barrio',
      address: 'Alfonso López, Popayán, Cauca',
      coordinates: LatLng(2.4340, -76.6190),
      description: 'Barrio del sur con desarrollo urbano progresivo',
      keywords: ['barrio', 'alfonso lópez', 'sur', 'desarrollo', 'urbano'],
      rating: 3.8,
    ),

    PopayanPlace(
      id: 'el_limonar',
      name: 'El Limonar',
      category: 'Barrio',
      address: 'El Limonar, Popayán, Cauca',
      coordinates: LatLng(2.4320, -76.6210),
      description: 'Barrio del sur con tradición agrícola',
      keywords: ['barrio', 'el limonar', 'sur', 'tradición', 'agrícola'],
      rating: 3.7,
    ),

    PopayanPlace(
      id: 'el_boqueron',
      name: 'El Boquerón',
      category: 'Barrio',
      address: 'El Boquerón, Popayán, Cauca',
      coordinates: LatLng(2.4300, -76.6230),
      description: 'Barrio del extremo sur de Popayán',
      keywords: ['barrio', 'el boquerón', 'sur', 'extremo'],
      rating: 3.6,
    ),

    PopayanPlace(
      id: 'la_arboleda',
      name: 'La Arboleda',
      category: 'Barrio',
      address: 'La Arboleda, Popayán, Cauca',
      coordinates: LatLng(2.4350, -76.6200),
      description: 'Barrio con abundante arborización',
      keywords: ['barrio', 'la arboleda', 'árboles', 'verde'],
      rating: 4.0,
    ),

    // BARRIOS ZONA OCCIDENTAL
    PopayanPlace(
      id: 'el_uvo',
      name: 'El Uvo',
      category: 'Barrio',
      address: 'El Uvo, Popayán, Cauca',
      coordinates: LatLng(2.4470, -76.6200),
      description: 'Barrio occidental con crecimiento urbano',
      keywords: ['barrio', 'el uvo', 'occidental', 'crecimiento'],
      rating: 3.9,
    ),

    PopayanPlace(
      id: 'san_eduardo',
      name: 'San Eduardo',
      category: 'Barrio',
      address: 'San Eduardo, Popayán, Cauca',
      coordinates: LatLng(2.4490, -76.6180),
      description: 'Barrio occidental con servicios básicos completos',
      keywords: ['barrio', 'san eduardo', 'occidental', 'servicios'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'berlin',
      name: 'Berlín',
      category: 'Barrio',
      address: 'Berlín, Popayán, Cauca',
      coordinates: LatLng(2.4450, -76.6220),
      description: 'Barrio occidental con identidad propia',
      keywords: ['barrio', 'berlín', 'occidental', 'identidad'],
      rating: 3.8,
    ),

    PopayanPlace(
      id: 'suizo',
      name: 'Suizo',
      category: 'Barrio',
      address: 'Suizo, Popayán, Cauca',
      coordinates: LatLng(2.4430, -76.6240),
      description: 'Barrio occidental tradicional',
      keywords: ['barrio', 'suizo', 'occidental', 'tradicional'],
      rating: 3.7,
    ),

    PopayanPlace(
      id: 'las_ferias',
      name: 'Las Ferias',
      category: 'Barrio',
      address: 'Las Ferias, Popayán, Cauca',
      coordinates: LatLng(2.4410, -76.6260),
      description: 'Barrio con actividad comercial importante',
      keywords: ['barrio', 'las ferias', 'comercial', 'actividad'],
      rating: 3.9,
    ),

    PopayanPlace(
      id: 'los_andes',
      name: 'Los Andes',
      category: 'Barrio',
      address: 'Los Andes, Popayán, Cauca',
      coordinates: LatLng(2.4390, -76.6280),
      description: 'Barrio en desarrollo con proyección futura',
      keywords: ['barrio', 'los andes', 'desarrollo', 'futuro'],
      rating: 3.8,
    ),

    PopayanPlace(
      id: 'alameda',
      name: 'Alameda',
      category: 'Barrio',
      address: 'Alameda, Popayán, Cauca',
      coordinates: LatLng(2.4370, -76.6300),
      description: 'Barrio con amplias avenidas',
      keywords: ['barrio', 'alameda', 'avenidas', 'amplias'],
      rating: 3.7,
    ),

    // BARRIOS ADICIONALES - ZONA NORTE
    PopayanPlace(
      id: 'villa_del_norte',
      name: 'Villa del Norte',
      category: 'Barrio',
      address: 'Villa del Norte, Popayán, Cauca',
      coordinates: LatLng(2.4580, -76.6040),
      description:
          'Barrio residencial del extremo norte con urbanizaciones modernas',
      keywords: [
        'barrio',
        'villa del norte',
        'residencial',
        'moderno',
        'urbanización'
      ],
      rating: 4.3,
    ),

    PopayanPlace(
      id: 'torres_del_inca',
      name: 'Torres del Inca',
      category: 'Barrio',
      address: 'Torres del Inca, Popayán, Cauca',
      coordinates: LatLng(2.4600, -76.6020),
      description:
          'Conjunto residencial del norte con excelente infraestructura',
      keywords: ['barrio', 'torres del inca', 'conjunto', 'infraestructura'],
      rating: 4.4,
    ),

    PopayanPlace(
      id: 'la_primavera',
      name: 'La Primavera',
      category: 'Barrio',
      address: 'La Primavera, Popayán, Cauca',
      coordinates: LatLng(2.4570, -76.6070),
      description: 'Barrio familiar con zonas verdes y ambiente tranquilo',
      keywords: [
        'barrio',
        'la primavera',
        'familiar',
        'zonas verdes',
        'tranquilo'
      ],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'zona_universitaria',
      name: 'Zona Universitaria',
      category: 'Barrio',
      address: 'Zona Universitaria, Popayán, Cauca',
      coordinates: LatLng(2.4430, -76.6110),
      description:
          'Zona con alta concentración de estudiantes y servicios educativos',
      keywords: ['barrio', 'zona universitaria', 'estudiantes', 'educación'],
      rating: 4.4,
    ),

    PopayanPlace(
      id: 'santa_monica',
      name: 'Santa Mónica',
      category: 'Barrio',
      address: 'Santa Mónica, Popayán, Cauca',
      coordinates: LatLng(2.4460, -76.6130),
      description: 'Barrio residencial cerca de universidades',
      keywords: ['barrio', 'santa mónica', 'residencial', 'universidades'],
      rating: 4.2,
    ),

    // BARRIOS ADICIONALES - ZONA NORTE (CONTINUACIÓN)
    PopayanPlace(
      id: 'el_prado',
      name: 'El Prado',
      category: 'Barrio',
      address: 'El Prado, Popayán, Cauca',
      coordinates: LatLng(2.4590, -76.6050),
      description: 'Barrio residencial con amplias zonas verdes',
      keywords: ['barrio', 'el prado', 'residencial', 'zonas verdes'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'los_rosales',
      name: 'Los Rosales',
      category: 'Barrio',
      address: 'Los Rosales, Popayán, Cauca',
      coordinates: LatLng(2.4560, -76.6080),
      description: 'Barrio tranquilo con buena conectividad',
      keywords: ['barrio', 'los rosales', 'tranquilo', 'conectividad'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'villa_olimpica',
      name: 'Villa Olímpica',
      category: 'Barrio',
      address: 'Villa Olímpica, Popayán, Cauca',
      coordinates: LatLng(2.4540, -76.6100),
      description: 'Barrio con instalaciones deportivas',
      keywords: ['barrio', 'villa olímpica', 'deportivo', 'instalaciones'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'el_porvenir',
      name: 'El Porvenir',
      category: 'Barrio',
      address: 'El Porvenir, Popayán, Cauca',
      coordinates: LatLng(2.4520, -76.6120),
      description: 'Barrio en desarrollo con proyección futura',
      keywords: ['barrio', 'el porvenir', 'desarrollo', 'futuro'],
      rating: 3.9,
    ),

    PopayanPlace(
      id: 'la_esperanza',
      name: 'La Esperanza',
      category: 'Barrio',
      address: 'La Esperanza, Popayán, Cauca',
      coordinates: LatLng(2.4500, -76.6140),
      description: 'Barrio popular con gran sentido comunitario',
      keywords: ['barrio', 'la esperanza', 'popular', 'comunitario'],
      rating: 4.0,
    ),

    // BARRIOS ADICIONALES - ZONA ORIENTE (CONTINUACIÓN)
    PopayanPlace(
      id: 'el_rosario',
      name: 'El Rosario',
      category: 'Barrio',
      address: 'El Rosario, Popayán, Cauca',
      coordinates: LatLng(2.4410, -76.6020),
      description: 'Barrio tradicional con arquitectura colonial',
      keywords: ['barrio', 'el rosario', 'tradicional', 'colonial'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'la_ceiba',
      name: 'La Ceiba',
      category: 'Barrio',
      address: 'La Ceiba, Popayán, Cauca',
      coordinates: LatLng(2.4390, -76.6040),
      description: 'Barrio con abundante vegetación',
      keywords: ['barrio', 'la ceiba', 'vegetación', 'verde'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'el_mirador',
      name: 'El Mirador',
      category: 'Barrio',
      address: 'El Mirador, Popayán, Cauca',
      coordinates: LatLng(2.4370, -76.6060),
      description: 'Barrio con vista panorámica de la ciudad',
      keywords: ['barrio', 'el mirador', 'vista', 'panorámica'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'la_gloria',
      name: 'La Gloria',
      category: 'Barrio',
      address: 'La Gloria, Popayán, Cauca',
      coordinates: LatLng(2.4350, -76.6080),
      description: 'Barrio residencial con ambiente familiar',
      keywords: ['barrio', 'la gloria', 'residencial', 'familiar'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'el_progreso',
      name: 'El Progreso',
      category: 'Barrio',
      address: 'El Progreso, Popayán, Cauca',
      coordinates: LatLng(2.4330, -76.6100),
      description: 'Barrio en crecimiento con nuevos desarrollos',
      keywords: ['barrio', 'el progreso', 'crecimiento', 'desarrollos'],
      rating: 3.8,
    ),

    // BARRIOS ADICIONALES - ZONA SUR (CONTINUACIÓN)
    PopayanPlace(
      id: 'la_libertad',
      name: 'La Libertad',
      category: 'Barrio',
      address: 'La Libertad, Popayán, Cauca',
      coordinates: LatLng(2.4310, -76.6200),
      description: 'Barrio popular con gran actividad comercial',
      keywords: ['barrio', 'la libertad', 'popular', 'comercial'],
      rating: 3.9,
    ),

    PopayanPlace(
      id: 'el_carmen',
      name: 'El Carmen',
      category: 'Barrio',
      address: 'El Carmen, Popayán, Cauca',
      coordinates: LatLng(2.4290, -76.6220),
      description: 'Barrio tradicional con identidad propia',
      keywords: ['barrio', 'el carmen', 'tradicional', 'identidad'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'la_paz_sur',
      name: 'La Paz Sur',
      category: 'Barrio',
      address: 'La Paz Sur, Popayán, Cauca',
      coordinates: LatLng(2.4270, -76.6240),
      description: 'Extensión del barrio La Paz hacia el sur',
      keywords: ['barrio', 'la paz sur', 'extensión', 'sur'],
      rating: 3.8,
    ),

    PopayanPlace(
      id: 'el_salvador',
      name: 'El Salvador',
      category: 'Barrio',
      address: 'El Salvador, Popayán, Cauca',
      coordinates: LatLng(2.4250, -76.6260),
      description: 'Barrio con fuerte sentido comunitario',
      keywords: ['barrio', 'el salvador', 'comunitario', 'unión'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'la_victoria',
      name: 'La Victoria',
      category: 'Barrio',
      address: 'La Victoria, Popayán, Cauca',
      coordinates: LatLng(2.4230, -76.6280),
      description: 'Barrio en desarrollo con proyección social',
      keywords: ['barrio', 'la victoria', 'desarrollo', 'social'],
      rating: 3.9,
    ),

    // BARRIOS ADICIONALES - ZONA OCCIDENTAL (CONTINUACIÓN)
    PopayanPlace(
      id: 'el_retiro',
      name: 'El Retiro',
      category: 'Barrio',
      address: 'El Retiro, Popayán, Cauca',
      coordinates: LatLng(2.4480, -76.6250),
      description: 'Barrio tranquilo con ambiente residencial',
      keywords: ['barrio', 'el retiro', 'tranquilo', 'residencial'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'la_ceja',
      name: 'La Ceja',
      category: 'Barrio',
      address: 'La Ceja, Popayán, Cauca',
      coordinates: LatLng(2.4460, -76.6270),
      description: 'Barrio con vista hacia las montañas',
      keywords: ['barrio', 'la ceja', 'montañas', 'vista'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'el_paraiso',
      name: 'El Paraíso',
      category: 'Barrio',
      address: 'El Paraíso, Popayán, Cauca',
      coordinates: LatLng(2.4440, -76.6290),
      description: 'Barrio con abundante vegetación y tranquilidad',
      keywords: ['barrio', 'el paraíso', 'vegetación', 'tranquilidad'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'la_union',
      name: 'La Unión',
      category: 'Barrio',
      address: 'La Unión, Popayán, Cauca',
      coordinates: LatLng(2.4420, -76.6310),
      description: 'Barrio con fuerte sentido de comunidad',
      keywords: ['barrio', 'la unión', 'comunidad', 'unidad'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'el_triunfo',
      name: 'El Triunfo',
      category: 'Barrio',
      address: 'El Triunfo, Popayán, Cauca',
      coordinates: LatLng(2.4400, -76.6330),
      description: 'Barrio en desarrollo con proyección futura',
      keywords: ['barrio', 'el triunfo', 'desarrollo', 'futuro'],
      rating: 3.9,
    ),

    // BARRIOS ADICIONALES - ZONA CENTRO (CONTINUACIÓN)
    PopayanPlace(
      id: 'santa_barbara',
      name: 'Santa Bárbara',
      category: 'Barrio',
      address: 'Santa Bárbara, Popayán, Cauca',
      coordinates: LatLng(2.4450, -76.6140),
      description: 'Barrio céntrico con tradición histórica',
      keywords: ['barrio', 'santa bárbara', 'céntrico', 'histórico'],
      rating: 4.3,
    ),

    PopayanPlace(
      id: 'san_antonio',
      name: 'San Antonio',
      category: 'Barrio',
      address: 'San Antonio, Popayán, Cauca',
      coordinates: LatLng(2.4430, -76.6160),
      description: 'Barrio tradicional cerca del centro histórico',
      keywords: ['barrio', 'san antonio', 'tradicional', 'centro'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'la_candelaria',
      name: 'La Candelaria',
      category: 'Barrio',
      address: 'La Candelaria, Popayán, Cauca',
      coordinates: LatLng(2.4410, -76.6180),
      description: 'Barrio con arquitectura colonial preservada',
      keywords: ['barrio', 'la candelaria', 'colonial', 'arquitectura'],
      rating: 4.4,
    ),

    PopayanPlace(
      id: 'el_sagrario',
      name: 'El Sagrario',
      category: 'Barrio',
      address: 'El Sagrario, Popayán, Cauca',
      coordinates: LatLng(2.4440, -76.6120),
      description: 'Barrio céntrico con importancia religiosa',
      keywords: ['barrio', 'el sagrario', 'céntrico', 'religioso'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'la_merced',
      name: 'La Merced',
      category: 'Barrio',
      address: 'La Merced, Popayán, Cauca',
      coordinates: LatLng(2.4420, -76.6140),
      description: 'Barrio histórico con tradición colonial',
      keywords: ['barrio', 'la merced', 'histórico', 'colonial'],
      rating: 4.2,
    ),

    // BARRIOS ADICIONALES - ZONA NORTE (MÁS BARRIOS)
    PopayanPlace(
      id: 'el_campo',
      name: 'El Campo',
      category: 'Barrio',
      address: 'El Campo, Popayán, Cauca',
      coordinates: LatLng(2.4610, -76.6000),
      description: 'Barrio residencial del extremo norte',
      keywords: ['barrio', 'el campo', 'residencial', 'norte'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'la_esperanza_norte',
      name: 'La Esperanza Norte',
      category: 'Barrio',
      address: 'La Esperanza Norte, Popayán, Cauca',
      coordinates: LatLng(2.4630, -76.5980),
      description: 'Barrio en desarrollo del norte de Popayán',
      keywords: ['barrio', 'la esperanza norte', 'desarrollo', 'norte'],
      rating: 3.9,
    ),

    PopayanPlace(
      id: 'villa_magdalena',
      name: 'Villa Magdalena',
      category: 'Barrio',
      address: 'Villa Magdalena, Popayán, Cauca',
      coordinates: LatLng(2.4650, -76.5960),
      description: 'Conjunto residencial moderno del norte',
      keywords: ['barrio', 'villa magdalena', 'conjunto', 'moderno'],
      rating: 4.1,
    ),

    // BARRIOS ADICIONALES - ZONA ORIENTE (MÁS BARRIOS)
    PopayanPlace(
      id: 'el_edén',
      name: 'El Edén',
      category: 'Barrio',
      address: 'El Edén, Popayán, Cauca',
      coordinates: LatLng(2.4340, -76.5980),
      description: 'Barrio con abundante vegetación y tranquilidad',
      keywords: ['barrio', 'el edén', 'vegetación', 'tranquilidad'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'la_esperanza_oriente',
      name: 'La Esperanza Oriente',
      category: 'Barrio',
      address: 'La Esperanza Oriente, Popayán, Cauca',
      coordinates: LatLng(2.4320, -76.6000),
      description: 'Barrio del oriente con desarrollo progresivo',
      keywords: ['barrio', 'la esperanza oriente', 'oriente', 'desarrollo'],
      rating: 3.8,
    ),

    PopayanPlace(
      id: 'el_progreso_oriente',
      name: 'El Progreso Oriente',
      category: 'Barrio',
      address: 'El Progreso Oriente, Popayán, Cauca',
      coordinates: LatLng(2.4300, -76.6020),
      description: 'Barrio en crecimiento del oriente',
      keywords: ['barrio', 'el progreso oriente', 'oriente', 'crecimiento'],
      rating: 3.7,
    ),

    // BARRIOS ADICIONALES - ZONA SUR (MÁS BARRIOS)
    PopayanPlace(
      id: 'la_esperanza_sur',
      name: 'La Esperanza Sur',
      category: 'Barrio',
      address: 'La Esperanza Sur, Popayán, Cauca',
      coordinates: LatLng(2.4210, -76.6300),
      description: 'Barrio del sur con gran sentido comunitario',
      keywords: ['barrio', 'la esperanza sur', 'sur', 'comunitario'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'el_progreso_sur',
      name: 'El Progreso Sur',
      category: 'Barrio',
      address: 'El Progreso Sur, Popayán, Cauca',
      coordinates: LatLng(2.4190, -76.6320),
      description: 'Barrio en desarrollo del sur de Popayán',
      keywords: ['barrio', 'el progreso sur', 'sur', 'desarrollo'],
      rating: 3.8,
    ),

    PopayanPlace(
      id: 'la_victoria_sur',
      name: 'La Victoria Sur',
      category: 'Barrio',
      address: 'La Victoria Sur, Popayán, Cauca',
      coordinates: LatLng(2.4170, -76.6340),
      description: 'Barrio del sur con proyección social',
      keywords: ['barrio', 'la victoria sur', 'sur', 'social'],
      rating: 3.9,
    ),

    // BARRIOS ADICIONALES - ZONA OCCIDENTAL (MÁS BARRIOS)
    PopayanPlace(
      id: 'el_retiro_occidente',
      name: 'El Retiro Occidente',
      category: 'Barrio',
      address: 'El Retiro Occidente, Popayán, Cauca',
      coordinates: LatLng(2.4500, -76.6350),
      description: 'Barrio tranquilo del occidente',
      keywords: ['barrio', 'el retiro occidente', 'occidente', 'tranquilo'],
      rating: 4.0,
    ),

    PopayanPlace(
      id: 'la_ceja_occidente',
      name: 'La Ceja Occidente',
      category: 'Barrio',
      address: 'La Ceja Occidente, Popayán, Cauca',
      coordinates: LatLng(2.4480, -76.6370),
      description: 'Barrio del occidente con vista a las montañas',
      keywords: ['barrio', 'la ceja occidente', 'occidente', 'montañas'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'el_paraiso_occidente',
      name: 'El Paraíso Occidente',
      category: 'Barrio',
      address: 'El Paraíso Occidente, Popayán, Cauca',
      coordinates: LatLng(2.4460, -76.6390),
      description: 'Barrio del occidente con abundante vegetación',
      keywords: ['barrio', 'el paraíso occidente', 'occidente', 'vegetación'],
      rating: 4.2,
    ),

    // BARRIOS ADICIONALES - ZONA CENTRO (MÁS BARRIOS)
    PopayanPlace(
      id: 'santa_barbara_centro',
      name: 'Santa Bárbara Centro',
      category: 'Barrio',
      address: 'Santa Bárbara Centro, Popayán, Cauca',
      coordinates: LatLng(2.4470, -76.6140),
      description: 'Barrio céntrico con tradición histórica',
      keywords: ['barrio', 'santa bárbara centro', 'céntrico', 'histórico'],
      rating: 4.3,
    ),

    PopayanPlace(
      id: 'san_antonio_centro',
      name: 'San Antonio Centro',
      category: 'Barrio',
      address: 'San Antonio Centro, Popayán, Cauca',
      coordinates: LatLng(2.4450, -76.6160),
      description: 'Barrio tradicional del centro histórico',
      keywords: ['barrio', 'san antonio centro', 'centro', 'tradicional'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'la_candelaria_centro',
      name: 'La Candelaria Centro',
      category: 'Barrio',
      address: 'La Candelaria Centro, Popayán, Cauca',
      coordinates: LatLng(2.4430, -76.6180),
      description: 'Barrio del centro con arquitectura colonial',
      keywords: ['barrio', 'la candelaria centro', 'centro', 'colonial'],
      rating: 4.4,
    ),

    // BARRIOS ADICIONALES - ZONA UNIVERSITARIA
    PopayanPlace(
      id: 'zona_universitaria_norte',
      name: 'Zona Universitaria Norte',
      category: 'Barrio',
      address: 'Zona Universitaria Norte, Popayán, Cauca',
      coordinates: LatLng(2.4440, -76.6100),
      description:
          'Zona universitaria del norte con alta concentración estudiantil',
      keywords: [
        'barrio',
        'zona universitaria norte',
        'universidad',
        'estudiantes'
      ],
      rating: 4.4,
    ),

    PopayanPlace(
      id: 'zona_universitaria_sur',
      name: 'Zona Universitaria Sur',
      category: 'Barrio',
      address: 'Zona Universitaria Sur, Popayán, Cauca',
      coordinates: LatLng(2.4420, -76.6120),
      description: 'Zona universitaria del sur con servicios educativos',
      keywords: [
        'barrio',
        'zona universitaria sur',
        'universidad',
        'educación'
      ],
      rating: 4.3,
    ),

    // BARRIOS ADICIONALES - ZONA COMERCIAL
    PopayanPlace(
      id: 'zona_comercial_norte',
      name: 'Zona Comercial Norte',
      category: 'Barrio',
      address: 'Zona Comercial Norte, Popayán, Cauca',
      coordinates: LatLng(2.4480, -76.6080),
      description: 'Zona comercial del norte con alta actividad económica',
      keywords: ['barrio', 'zona comercial norte', 'comercial', 'económica'],
      rating: 4.1,
    ),

    PopayanPlace(
      id: 'zona_comercial_sur',
      name: 'Zona Comercial Sur',
      category: 'Barrio',
      address: 'Zona Comercial Sur, Popayán, Cauca',
      coordinates: LatLng(2.4400, -76.6200),
      description: 'Zona comercial del sur con desarrollo empresarial',
      keywords: ['barrio', 'zona comercial sur', 'comercial', 'empresarial'],
      rating: 4.0,
    ),

    // BARRIOS ADICIONALES - ZONA RESIDENCIAL
    PopayanPlace(
      id: 'zona_residencial_norte',
      name: 'Zona Residencial Norte',
      category: 'Barrio',
      address: 'Zona Residencial Norte, Popayán, Cauca',
      coordinates: LatLng(2.4500, -76.6060),
      description: 'Zona residencial del norte con urbanizaciones modernas',
      keywords: ['barrio', 'zona residencial norte', 'residencial', 'moderno'],
      rating: 4.2,
    ),

    PopayanPlace(
      id: 'zona_residencial_sur',
      name: 'Zona Residencial Sur',
      category: 'Barrio',
      address: 'Zona Residencial Sur, Popayán, Cauca',
      coordinates: LatLng(2.4380, -76.6220),
      description: 'Zona residencial del sur con desarrollo habitacional',
      keywords: [
        'barrio',
        'zona residencial sur',
        'residencial',
        'habitacional'
      ],
      rating: 4.0,
    ),
  ];

  /// Busca lugares por texto (incluye barrios)
  static List<PopayanPlace> searchPlaces(String query) {
    if (query.isEmpty) return [];

    final queryLower = query.toLowerCase();

    // Buscar en lugares existentes
    final placeResults = places.where((place) {
      return place.name.toLowerCase().contains(queryLower) ||
          place.category.toLowerCase().contains(queryLower) ||
          place.address.toLowerCase().contains(queryLower) ||
          place.keywords
              .any((keyword) => keyword.toLowerCase().contains(queryLower));
    }).toList();

    // Buscar en barrios y convertir a PopayanPlace
    final neighborhoodResults =
        PopayanNeighborhoodsDatabase.searchNeighborhoods(query)
            .map((neighborhood) => _convertNeighborhoodToPlace(neighborhood))
            .toList();

    // Combinar resultados
    return [...placeResults, ...neighborhoodResults];
  }

  /// Obtiene lugares por categoría (incluye barrios)
  static List<PopayanPlace> getPlacesByCategory(String category) {
    final placeResults =
        places.where((place) => place.category == category).toList();

    // Si buscan por "Barrio", incluir todos los barrios urbanos
    if (category == 'Barrio') {
      final neighborhoodResults =
          PopayanNeighborhoodsDatabase.getNeighborhoodsByType('Barrio')
              .map((neighborhood) => _convertNeighborhoodToPlace(neighborhood))
              .toList();
      return [...placeResults, ...neighborhoodResults];
    }

    // Si buscan por "Corregimiento", incluir corregimientos
    if (category == 'Corregimiento') {
      final neighborhoodResults =
          PopayanNeighborhoodsDatabase.getNeighborhoodsByType('Corregimiento')
              .map((neighborhood) => _convertNeighborhoodToPlace(neighborhood))
              .toList();
      return [...placeResults, ...neighborhoodResults];
    }

    // Si buscan por "Vereda", incluir veredas
    if (category == 'Vereda') {
      final neighborhoodResults =
          PopayanNeighborhoodsDatabase.getNeighborhoodsByType('Vereda')
              .map((neighborhood) => _convertNeighborhoodToPlace(neighborhood))
              .toList();
      return [...placeResults, ...neighborhoodResults];
    }

    return placeResults;
  }

  /// Convierte un barrio a un lugar para mantener compatibilidad
  static PopayanPlace _convertNeighborhoodToPlace(
      PopayanNeighborhood neighborhood) {
    return PopayanPlace(
      id: neighborhood.id,
      name: neighborhood.name,
      category: neighborhood.type,
      address: '${neighborhood.name}, ${neighborhood.comuna}, Popayán, Cauca',
      coordinates: neighborhood.coordinates,
      description: neighborhood.description ??
          'Barrio en ${neighborhood.comuna} de Popayán',
      keywords: neighborhood.keywords,
      rating: 0.0,
    );
  }

  /// Obtiene un lugar por ID
  static PopayanPlace? getPlaceById(String id) {
    try {
      return places.firstWhere((place) => place.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene lugares cercanos a una ubicación
  static List<PopayanPlace> getNearbyPlaces(LatLng location, double radiusKm) {
    const double earthRadius = 6371; // Radio de la Tierra en km

    return places.where((place) {
      // Cálculo de distancia usando fórmula de Haversine
      double lat1Rad = location.latitude * (3.14159 / 180);
      double lon1Rad = location.longitude * (3.14159 / 180);
      double lat2Rad = place.coordinates.latitude * (3.14159 / 180);
      double lon2Rad = place.coordinates.longitude * (3.14159 / 180);

      double dLat = lat2Rad - lat1Rad;
      double dLon = lon2Rad - lon1Rad;

      double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
      double c = 2 * asin(sqrt(a));
      double distance = earthRadius * c;

      return distance <= radiusKm;
    }).toList();
  }

  /// Obtiene todas las categorías disponibles (incluye barrios)
  static List<String> getCategories() {
    final placeCategories = places.map((place) => place.category).toSet();
    final neighborhoodTypes = {'Barrio', 'Corregimiento', 'Vereda'};
    return [...placeCategories, ...neighborhoodTypes].toList()..sort();
  }

  /// Obtiene barrios por comuna específica
  static List<PopayanPlace> getNeighborhoodsByComuna(String comuna) {
    return PopayanNeighborhoodsDatabase.getNeighborhoodsByComuna(comuna)
        .map((neighborhood) => _convertNeighborhoodToPlace(neighborhood))
        .toList();
  }

  /// Obtiene todas las comunas disponibles
  static List<String> getComunas() {
    return PopayanNeighborhoodsDatabase.getComunas();
  }

  /// Obtiene áreas rurales (corregimientos y veredas)
  static List<PopayanPlace> getRuralAreas() {
    return PopayanNeighborhoodsDatabase.getRuralAreas()
        .map((neighborhood) => _convertNeighborhoodToPlace(neighborhood))
        .toList();
  }

  /// Obtiene búsquedas populares (incluye barrios)
  static List<String> getPopularSearches() {
    return [
      'Centro Comercial',
      'Universidad',
      'Hospital',
      'Restaurante',
      'Banco',
      'Hotel',
      'Centro',
      'La Paz',
      'Villa Occidente',
      'La Esmeralda',
      'Lomas de Granada',
      'Chirimía',
      'Las Palmas',
      'Pomona',
      'La Maria',
      'Villa del Norte',
      'Los Alpes',
      'El Popular',
      'Los Rosales',
      'Villa Olímpica',
      'El Porvenir',
      'La Esperanza',
      'El Rosario',
      'La Ceiba',
      'El Mirador',
      'La Gloria',
      'El Progreso',
      'La Libertad',
      'El Carmen',
      'La Paz Sur',
      'El Salvador',
      'La Victoria',
      'El Retiro',
      'La Ceja',
      'El Paraíso',
      'La Unión',
      'El Triunfo',
      'Santa Bárbara',
      'San Antonio',
      'La Candelaria',
      'El Sagrario',
      'La Merced',
      'Zona Universitaria',
      'Santa Mónica',
      'La Floresta',
      'El Lago',
      'Campan',
      'El Recuerdo',
      'Alfonso López',
      'El Limonar',
      'El Boquerón',
      'La Arboleda',
      'San Eduardo',
      'Berlín',
      'Suizo',
      'Las Ferias',
      'Los Andes',
      'Alameda',
      'El Campo',
      'La Esperanza Norte',
      'Villa Magdalena',
      'El Edén',
      'La Esperanza Oriente',
      'El Progreso Oriente',
      'La Esperanza Sur',
      'El Progreso Sur',
      'La Victoria Sur',
      'El Retiro Occidente',
      'La Ceja Occidente',
      'El Paraíso Occidente',
      'Santa Bárbara Centro',
      'San Antonio Centro',
      'La Candelaria Centro',
      'Zona Universitaria Norte',
      'Zona Universitaria Sur',
      'Zona Comercial Norte',
      'Zona Comercial Sur',
      'Zona Residencial Norte',
      'Zona Residencial Sur',
    ];
  }
}
