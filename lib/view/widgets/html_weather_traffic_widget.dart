import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlWeatherTrafficWidget extends StatefulWidget {
  final String temperature;
  final String weatherCondition;
  final String trafficStatus;
  final int trafficLevel; // 1-5 scale

  const HtmlWeatherTrafficWidget({
    super.key,
    required this.temperature,
    required this.weatherCondition,
    required this.trafficStatus,
    required this.trafficLevel,
  });

  @override
  State<HtmlWeatherTrafficWidget> createState() =>
      _HtmlWeatherTrafficWidgetState();
}

class _HtmlWeatherTrafficWidgetState extends State<HtmlWeatherTrafficWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..clearCache()
      ..loadHtmlString(_getHtmlContent());
  }

  String _getWeatherIcon() {
    switch (widget.weatherCondition.toLowerCase()) {
      case 'soleado':
      case 'despejado':
        return '☀️';
      case 'nublado':
      case 'parcialmente nublado':
        return '⛅';
      case 'lluvia':
      case 'llovizna':
        return '🌧️';
      case 'tormenta':
        return '⛈️';
      default:
        return '🌤️';
    }
  }

  String _getTrafficColor() {
    switch (widget.trafficLevel) {
      case 1:
        return '#4CAF50'; // Verde
      case 2:
        return '#8BC34A'; // Verde claro
      case 3:
        return '#FFC107'; // Amarillo
      case 4:
        return '#FF9800'; // Naranja
      case 5:
        return '#F44336'; // Rojo
      default:
        return '#4CAF50';
    }
  }

  String _getHtmlContent() {
    return '''
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Clima y Tráfico</title>
        <!-- Updated: ${DateTime.now().millisecondsSinceEpoch} -->
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #FF6A00 0%, #FFB366 100%);
                padding: 20px;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            .container {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                max-width: 400px;
                width: 100%;
            }
            
            .card {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 20px;
                padding: 25px;
                text-align: center;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.3);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                animation: slideIn 0.8s ease-out;
            }
            
            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.25);
            }
            
            .weather-card {
                animation-delay: 0.1s;
            }
            
            .traffic-card {
                animation-delay: 0.3s;
            }
            
            .icon {
                font-size: 3rem;
                margin-bottom: 15px;
                display: block;
                animation: bounce 2s infinite;
            }
            
            .weather-icon {
                animation-delay: 0.5s;
            }
            
            .traffic-icon {
                animation-delay: 1s;
            }
            
            .temperature {
                font-size: 2.5rem;
                font-weight: bold;
                color: #2d3436;
                margin-bottom: 8px;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
            }
            
            .condition {
                font-size: 1rem;
                color: #636e72;
                font-weight: 500;
                text-transform: capitalize;
            }
            
            .traffic-status {
                font-size: 1.2rem;
                font-weight: bold;
                margin-bottom: 10px;
                color: ${_getTrafficColor()};
            }
            
            .traffic-description {
                font-size: 0.9rem;
                color: #636e72;
                font-weight: 500;
            }
            
            .traffic-bars {
                display: flex;
                justify-content: center;
                gap: 4px;
                margin: 15px 0;
            }
            
            .bar {
                width: 8px;
                height: 20px;
                border-radius: 4px;
                background: #e0e0e0;
                transition: background 0.3s ease;
            }
            
            .bar.active {
                background: ${_getTrafficColor()};
                animation: pulse 1.5s infinite;
            }
            
            .header {
                grid-column: 1 / -1;
                text-align: center;
                color: white;
                margin-bottom: 10px;
                animation: fadeIn 1s ease-out;
            }
            
            .header h2 {
                font-size: 1.5rem;
                font-weight: bold;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                margin-bottom: 5px;
            }
            
            .header p {
                font-size: 0.9rem;
                opacity: 0.9;
            }
            
            @keyframes slideIn {
                from {
                    transform: translateY(30px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }
            
            @keyframes bounce {
                0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
                40% { transform: translateY(-10px); }
                60% { transform: translateY(-5px); }
            }
            
            @keyframes pulse {
                0% { opacity: 1; }
                50% { opacity: 0.6; }
                100% { opacity: 1; }
            }
            
            .update-time {
                grid-column: 1 / -1;
                text-align: center;
                color: rgba(255, 255, 255, 0.8);
                font-size: 0.8rem;
                margin-top: 10px;
                animation: fadeIn 1.2s ease-out;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>🌤️ Condiciones Actuales</h2>
                <p>Popayán, Cauca</p>
            </div>
            
            <div class="card weather-card">
                <span class="icon weather-icon">${_getWeatherIcon()}</span>
                <div class="temperature">${widget.temperature}°C</div>
                <div class="condition">${widget.weatherCondition}</div>
            </div>
            
            <div class="card traffic-card">
                <span class="icon traffic-icon">🚦</span>
                <div class="traffic-status">${widget.trafficStatus}</div>
                <div class="traffic-bars">
                    ${List.generate(5, (index) => '''
                        <div class="bar ${index < widget.trafficLevel ? 'active' : ''}"></div>
                    ''').join('')}
                </div>
                <div class="traffic-description">Nivel de tráfico</div>
            </div>
            
            <div class="update-time">
                Actualizado hace 2 minutos
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
