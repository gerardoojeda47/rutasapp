import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlStatsWidget extends StatefulWidget {
  final int activeBuses;
  final int totalRoutes;
  final int busStops;
  final String cityName;

  const HtmlStatsWidget({
    super.key,
    required this.activeBuses,
    required this.totalRoutes,
    required this.busStops,
    required this.cityName,
  });

  @override
  State<HtmlStatsWidget> createState() => _HtmlStatsWidgetState();
}

class _HtmlStatsWidgetState extends State<HtmlStatsWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..clearCache()
      ..loadHtmlString(_getHtmlContent());
  }

  String _getHtmlContent() {
    return '''
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Estadísticas ${widget.cityName}</title>
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
            }
            
            .stats-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                max-width: 600px;
                margin: 0 auto;
            }
            
            .stat-card {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                padding: 20px;
                text-align: center;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                animation: slideUp 0.6s ease-out;
            }
            
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
            }
            
            .stat-card:nth-child(1) { animation-delay: 0.1s; }
            .stat-card:nth-child(2) { animation-delay: 0.2s; }
            .stat-card:nth-child(3) { animation-delay: 0.3s; }
            
            .stat-icon {
                font-size: 2.5rem;
                margin-bottom: 10px;
                display: block;
            }
            
            .stat-number {
                font-size: 2rem;
                font-weight: bold;
                color: #FF6A00;
                margin-bottom: 5px;
                counter-reset: number;
                animation: countUp 2s ease-out;
            }
            
            .stat-label {
                font-size: 0.9rem;
                color: #666;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .city-header {
                text-align: center;
                color: white;
                margin-bottom: 30px;
                animation: fadeIn 1s ease-out;
            }
            
            .city-name {
                font-size: 1.8rem;
                font-weight: bold;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                margin-bottom: 5px;
            }
            
            .city-subtitle {
                font-size: 1rem;
                opacity: 0.9;
            }
            
            @keyframes slideUp {
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
            
            @keyframes countUp {
                from { 
                    transform: scale(0.5);
                    opacity: 0;
                }
                to { 
                    transform: scale(1);
                    opacity: 1;
                }
            }
            
            .pulse {
                animation: pulse 2s infinite;
            }
            
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.05); }
                100% { transform: scale(1); }
            }
        </style>
    </head>
    <body>
        <div class="city-header">
            <h1 class="city-name">${widget.cityName.toUpperCase()}</h1>
            <p class="city-subtitle">Estadísticas en Tiempo Real</p>
        </div>
        
        <div class="stats-container">
            <div class="stat-card">
                <span class="stat-icon">🚌</span>
                <div class="stat-number pulse">${widget.activeBuses}</div>
                <div class="stat-label">Buses Activos</div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">🛣️</span>
                <div class="stat-number">${widget.totalRoutes}</div>
                <div class="stat-label">Rutas Disponibles</div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">🚏</span>
                <div class="stat-number">${widget.busStops}</div>
                <div class="stat-label">Paradas de Bus</div>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
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
