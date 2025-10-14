import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlNewsWidget extends StatefulWidget {
  final List<NewsItem> newsItems;

  const HtmlNewsWidget({super.key, required this.newsItems});

  @override
  State<HtmlNewsWidget> createState() => _HtmlNewsWidgetState();
}

class _HtmlNewsWidgetState extends State<HtmlNewsWidget> {
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
    String newsItemsHtml = widget.newsItems
        .map(
          (item) =>
              '''
      <div class="news-item">
        <div class="news-icon">${item.icon}</div>
        <div class="news-content">
          <h3 class="news-title">${item.title}</h3>
          <p class="news-description">${item.description}</p>
          <span class="news-time">${item.timeAgo}</span>
        </div>
      </div>
    ''',
        )
        .join('');

    return '''
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Noticias del Transporte</title>
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
            
            .news-container {
                max-width: 500px;
                margin: 0 auto;
            }
            
            .header {
                text-align: center;
                color: white;
                margin-bottom: 25px;
                animation: fadeInDown 0.8s ease-out;
            }
            
            .header h1 {
                font-size: 1.5rem;
                font-weight: bold;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                margin-bottom: 5px;
            }
            
            .header p {
                font-size: 0.9rem;
                opacity: 0.9;
            }
            
            .news-item {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 12px;
                padding: 15px;
                margin-bottom: 15px;
                display: flex;
                align-items: flex-start;
                gap: 15px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                animation: slideInLeft 0.6s ease-out;
                animation-fill-mode: both;
            }
            
            .news-item:hover {
                transform: translateX(5px);
                box-shadow: 0 6px 25px rgba(0, 0, 0, 0.15);
            }
            
            .news-item:nth-child(2) { animation-delay: 0.1s; }
            .news-item:nth-child(3) { animation-delay: 0.2s; }
            .news-item:nth-child(4) { animation-delay: 0.3s; }
            .news-item:nth-child(5) { animation-delay: 0.4s; }
            
            .news-icon {
                font-size: 1.8rem;
                flex-shrink: 0;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, #FF6A00, #FFB366);
                border-radius: 50%;
                color: white;
                box-shadow: 0 2px 10px rgba(255, 106, 0, 0.3);
            }
            
            .news-content {
                flex: 1;
            }
            
            .news-title {
                font-size: 1rem;
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
                line-height: 1.3;
            }
            
            .news-description {
                font-size: 0.85rem;
                color: #666;
                line-height: 1.4;
                margin-bottom: 8px;
            }
            
            .news-time {
                font-size: 0.75rem;
                color: #999;
                font-weight: 500;
            }
            
            @keyframes fadeInDown {
                from {
                    transform: translateY(-20px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            
            @keyframes slideInLeft {
                from {
                    transform: translateX(-30px);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            
            .scroll-indicator {
                position: fixed;
                bottom: 20px;
                right: 20px;
                color: rgba(255, 255, 255, 0.7);
                font-size: 0.8rem;
                animation: bounce 2s infinite;
            }
            
            @keyframes bounce {
                0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
                40% { transform: translateY(-10px); }
                60% { transform: translateY(-5px); }
            }
        </style>
    </head>
    <body>
        <div class="news-container">
            <div class="header">
                <h1>🚌 Noticias del Transporte</h1>
                <p>Mantente informado sobre el transporte en Popayán</p>
            </div>
            
            $newsItemsHtml
        </div>
        
        <div class="scroll-indicator">
            Desliza para ver más ↕️
        </div>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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

class NewsItem {
  final String icon;
  final String title;
  final String description;
  final String timeAgo;

  NewsItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.timeAgo,
  });
}

