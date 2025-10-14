import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlBannerWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;

  const HtmlBannerWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.primaryColor = const Color(0xFFFF6A00),
    this.secondaryColor = const Color(0xFFFFB366),
  });

  @override
  State<HtmlBannerWidget> createState() => _HtmlBannerWidgetState();
}

class _HtmlBannerWidgetState extends State<HtmlBannerWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_getHtmlContent());
  }

  String _getHtmlContent() {
    return '''
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ROUWHITE Banner</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, ${_colorToHex(widget.primaryColor)} 0%, ${_colorToHex(widget.secondaryColor)} 100%);
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
            }
            
            .banner-container {
                text-align: center;
                color: white;
                position: relative;
                z-index: 2;
            }
            
            .title {
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 0.5rem;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                animation: slideInFromTop 1s ease-out;
            }
            
            .subtitle {
                font-size: 1.2rem;
                opacity: 0.9;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
                animation: slideInFromBottom 1s ease-out 0.3s both;
            }
            
            .floating-icons {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                pointer-events: none;
                z-index: 1;
            }
            
            .icon {
                position: absolute;
                color: rgba(255,255,255,0.1);
                font-size: 2rem;
                animation: float 6s ease-in-out infinite;
            }
            
            .icon:nth-child(1) { top: 20%; left: 10%; animation-delay: 0s; }
            .icon:nth-child(2) { top: 60%; left: 80%; animation-delay: 2s; }
            .icon:nth-child(3) { top: 80%; left: 20%; animation-delay: 4s; }
            .icon:nth-child(4) { top: 30%; left: 70%; animation-delay: 1s; }
            .icon:nth-child(5) { top: 70%; left: 50%; animation-delay: 3s; }
            
            @keyframes slideInFromTop {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            
            @keyframes slideInFromBottom {
                from {
                    transform: translateY(30px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            
            @keyframes float {
                0%, 100% { transform: translateY(0px) rotate(0deg); }
                25% { transform: translateY(-20px) rotate(5deg); }
                50% { transform: translateY(-10px) rotate(-5deg); }
                75% { transform: translateY(-15px) rotate(3deg); }
            }
            
            .pulse-effect {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 200px;
                height: 200px;
                border: 2px solid rgba(255,255,255,0.2);
                border-radius: 50%;
                animation: pulse 3s ease-in-out infinite;
            }
            
            @keyframes pulse {
                0% {
                    transform: translate(-50%, -50%) scale(0.8);
                    opacity: 1;
                }
                100% {
                    transform: translate(-50%, -50%) scale(1.5);
                    opacity: 0;
                }
            }
        </style>
    </head>
    <body>
        <div class="floating-icons">
            <div class="icon">🚌</div>
            <div class="icon">📍</div>
            <div class="icon">🗺️</div>
            <div class="icon">⏰</div>
            <div class="icon">🚏</div>
        </div>
        
        <div class="pulse-effect"></div>
        
        <div class="banner-container">
            <h1 class="title">${widget.title}</h1>
            <p class="subtitle">${widget.subtitle}</p>
        </div>
    </body>
    </html>
    ''';
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
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

