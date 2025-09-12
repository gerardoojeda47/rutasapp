import 'package:flutter/material.dart';

/// Helper para manejar iconos de manera consistente
class IconHelper {
  /// Iconos de navegación principal
  static const IconData home = Icons.home;
  static const IconData routes = Icons.directions_bus;
  static const IconData stops = Icons.location_on;
  static const IconData favorites = Icons.star;
  static const IconData search = Icons.search;
  static const IconData menu = Icons.menu;
  static const IconData myLocation = Icons.my_location;
  static const IconData driver = Icons.drive_eta;
  static const IconData navigation = Icons.navigation;
  static const IconData clear = Icons.clear;
  static const IconData bugReport = Icons.bug_report;

  /// Iconos de categorías
  static const IconData restaurant = Icons.restaurant;
  static const IconData hospital = Icons.local_hospital;
  static const IconData bank = Icons.account_balance;
  static const IconData hotel = Icons.hotel;
  static const IconData supermarket = Icons.shopping_cart;
  static const IconData university = Icons.school;
  static const IconData shopping = Icons.shopping_bag;
  static const IconData place = Icons.place;
  static const IconData church = Icons.church;
  static const IconData terminal = Icons.directions_bus;
  static const IconData airport = Icons.flight;
  static const IconData park = Icons.park;
  static const IconData pharmacy = Icons.local_pharmacy;
  static const IconData neighborhood = Icons.location_city;

  /// Iconos de estado
  static const IconData locationOn = Icons.location_on;
  static const IconData locationOff = Icons.location_off;
  static const IconData check = Icons.check;
  static const IconData error = Icons.error;
  static const IconData warning = Icons.warning;
  static const IconData info = Icons.info;

  /// Iconos de acciones
  static const IconData add = Icons.add;
  static const IconData remove = Icons.remove;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData save = Icons.save;
  static const IconData refresh = Icons.refresh;
  static const IconData settings = Icons.settings;
  static const IconData help = Icons.help;
  static const IconData close = Icons.close;

  /// Iconos de transporte
  static const IconData bus = Icons.directions_bus;
  static const IconData busStop = Icons.directions_bus_filled;
  static const IconData route = Icons.route;
  static const IconData directions = Icons.directions;
  static const IconData map = Icons.map;
  static const IconData streetview = Icons.streetview;

  /// Iconos de tiempo
  static const IconData time = Icons.access_time;
  static const IconData schedule = Icons.schedule;
  static const IconData clock = Icons.watch_later;

  /// Iconos de dinero
  static const IconData money = Icons.attach_money;
  static const IconData payment = Icons.payment;
  static const IconData creditCard = Icons.credit_card;

  /// Iconos de tráfico
  static const IconData traffic = Icons.traffic;
  static const IconData speed = Icons.speed;

  /// Iconos de comunicación
  static const IconData phone = Icons.phone;
  static const IconData email = Icons.email;
  static const IconData message = Icons.message;

  /// Iconos de redes sociales
  static const IconData share = Icons.share;
  static const IconData favorite = Icons.favorite;
  static const IconData favoriteBorder = Icons.favorite_border;

  /// Iconos de UI
  static const IconData arrowBack = Icons.arrow_back;
  static const IconData arrowForward = Icons.arrow_forward;
  static const IconData arrowUp = Icons.keyboard_arrow_up;
  static const IconData arrowDown = Icons.keyboard_arrow_down;
  static const IconData arrowLeft = Icons.keyboard_arrow_left;
  static const IconData arrowRight = Icons.keyboard_arrow_right;

  /// Iconos de estado de carga
  static const IconData loading = Icons.hourglass_empty;
  static const IconData done = Icons.done;
  static const IconData pending = Icons.pending;

  /// Iconos de notificaciones
  static const IconData notification = Icons.notifications;
  static const IconData notificationOff = Icons.notifications_off;
  static const IconData notificationActive = Icons.notifications_active;

  /// Iconos de seguridad
  static const IconData security = Icons.security;
  static const IconData lock = Icons.lock;
  static const IconData lockOpen = Icons.lock_open;

  /// Iconos de clima
  static const IconData sunny = Icons.wb_sunny;
  static const IconData cloudy = Icons.cloud;
  static const IconData rainy = Icons.grain;

  /// Iconos de servicios
  static const IconData wifi = Icons.wifi;
  static const IconData bluetooth = Icons.bluetooth;
  static const IconData battery = Icons.battery_std;
  static const IconData signal = Icons.signal_cellular_4_bar;

  /// Iconos de mapas
  static const IconData mapMarker = Icons.place;
  static const IconData mapPin = Icons.location_on;
  static const IconData mapCenter = Icons.center_focus_strong;
  static const IconData mapZoom = Icons.zoom_in;
  static const IconData mapZoomOut = Icons.zoom_out;

  /// Iconos de puntos de interés
  static const IconData poiHospital = Icons.local_hospital;
  static const IconData poiSchool = Icons.school;
  static const IconData poiUniversity = Icons.account_balance;
  static const IconData poiPark = Icons.park;
  static const IconData poiChurch = Icons.church;
  static const IconData poiMall = Icons.shopping_bag;
  static const IconData poiRestaurant = Icons.restaurant;
  static const IconData poiBank = Icons.account_balance;
  static const IconData poiGasStation = Icons.local_gas_station;
  static const IconData poiPolice = Icons.local_police;
  static const IconData poiHotel = Icons.hotel;
  static const IconData poiMuseum = Icons.museum;
  static const IconData poiLibrary = Icons.local_library;
  static const IconData poiPharmacy = Icons.local_pharmacy;
  static const IconData poiSupermarket = Icons.shopping_cart;

  /// Método para obtener icono por nombre
  static IconData getIconByName(String name) {
    switch (name.toLowerCase()) {
      case 'home':
        return home;
      case 'routes':
        return routes;
      case 'stops':
        return stops;
      case 'favorites':
        return favorites;
      case 'search':
        return search;
      case 'menu':
        return menu;
      case 'my_location':
        return myLocation;
      case 'driver':
        return driver;
      case 'navigation':
        return navigation;
      case 'clear':
        return clear;
      case 'bug_report':
        return bugReport;
      case 'restaurant':
        return restaurant;
      case 'hospital':
        return hospital;
      case 'bank':
        return bank;
      case 'hotel':
        return hotel;
      case 'supermarket':
        return supermarket;
      case 'university':
        return university;
      case 'shopping':
        return shopping;
      case 'place':
        return place;
      case 'church':
        return church;
      case 'terminal':
        return terminal;
      case 'airport':
        return airport;
      case 'park':
        return park;
      case 'pharmacy':
        return pharmacy;
      case 'neighborhood':
        return neighborhood;
      case 'location_on':
        return locationOn;
      case 'location_off':
        return locationOff;
      case 'check':
        return check;
      case 'error':
        return error;
      case 'warning':
        return warning;
      case 'info':
        return info;
      case 'add':
        return add;
      case 'remove':
        return remove;
      case 'edit':
        return edit;
      case 'delete':
        return delete;
      case 'save':
        return save;
      case 'refresh':
        return refresh;
      case 'settings':
        return settings;
      case 'help':
        return help;
      case 'close':
        return close;
      case 'bus':
        return bus;
      case 'bus_stop':
        return busStop;
      case 'route':
        return route;
      case 'directions':
        return directions;
      case 'map':
        return map;
      case 'streetview':
        return streetview;
      case 'time':
        return time;
      case 'schedule':
        return schedule;
      case 'clock':
        return clock;
      case 'money':
        return money;
      case 'payment':
        return payment;
      case 'credit_card':
        return creditCard;
      case 'traffic':
        return traffic;
      case 'speed':
        return speed;
      case 'phone':
        return phone;
      case 'email':
        return email;
      case 'message':
        return message;
      case 'share':
        return share;
      case 'favorite':
        return favorite;
      case 'favorite_border':
        return favoriteBorder;
      case 'arrow_back':
        return arrowBack;
      case 'arrow_forward':
        return arrowForward;
      case 'arrow_up':
        return arrowUp;
      case 'arrow_down':
        return arrowDown;
      case 'arrow_left':
        return arrowLeft;
      case 'arrow_right':
        return arrowRight;
      case 'loading':
        return loading;
      case 'done':
        return done;
      case 'pending':
        return pending;
      case 'notification':
        return notification;
      case 'notification_off':
        return notificationOff;
      case 'notification_active':
        return notificationActive;
      case 'security':
        return security;
      case 'lock':
        return lock;
      case 'lock_open':
        return lockOpen;
      case 'sunny':
        return sunny;
      case 'cloudy':
        return cloudy;
      case 'rainy':
        return rainy;
      case 'wifi':
        return wifi;
      case 'bluetooth':
        return bluetooth;
      case 'battery':
        return battery;
      case 'signal':
        return signal;
      case 'map_marker':
        return mapMarker;
      case 'map_pin':
        return mapPin;
      case 'map_center':
        return mapCenter;
      case 'map_zoom':
        return mapZoom;
      case 'map_zoom_out':
        return mapZoomOut;
      case 'poi_hospital':
        return poiHospital;
      case 'poi_school':
        return poiSchool;
      case 'poi_university':
        return poiUniversity;
      case 'poi_park':
        return poiPark;
      case 'poi_church':
        return poiChurch;
      case 'poi_mall':
        return poiMall;
      case 'poi_restaurant':
        return poiRestaurant;
      case 'poi_bank':
        return poiBank;
      case 'poi_gas_station':
        return poiGasStation;
      case 'poi_police':
        return poiPolice;
      case 'poi_hotel':
        return poiHotel;
      case 'poi_museum':
        return poiMuseum;
      case 'poi_library':
        return poiLibrary;
      case 'poi_pharmacy':
        return poiPharmacy;
      case 'poi_supermarket':
        return poiSupermarket;
      default:
        return place; // Icono por defecto
    }
  }
}
