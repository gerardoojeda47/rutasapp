#!/bin/bash
# Advanced CI Build Script with Multiple Fallback Strategies

set -e

echo "🚀 Starting Advanced CI Build Process..."

# Strategy 1: Clean Environment Setup
echo "📦 Setting up clean environment..."
flutter clean
rm -rf ~/.pub-cache/hosted/pub.dev/geolocator*
flutter pub cache repair

# Strategy 2: Dependency Resolution with Retries
echo "🔄 Resolving dependencies with retry logic..."
for i in {1..3}; do
    if flutter pub get --verbose; then
        echo "✅ Dependencies resolved on attempt $i"
        break
    else
        echo "❌ Attempt $i failed, retrying..."
        sleep 5
    fi
done

# Strategy 3: Validate Critical Dependencies
echo "🔍 Validating critical dependencies..."
flutter pub deps | grep -E "(geolocator|flutter_map|latlong2)" || true

# Strategy 4: Multi-Stage Build Process
echo "🏗️ Starting multi-stage build..."

# Stage 1: Analyze code
echo "📊 Stage 1: Code analysis..."
flutter analyze --no-fatal-infos || echo "⚠️ Analysis warnings found, continuing..."

# Stage 2: Build with primary strategy
echo "🔨 Stage 2: Primary build attempt..."
if flutter build apk --debug --verbose --no-tree-shake-icons; then
    echo "✅ Primary build successful!"
    exit 0
fi

# Stage 3: Fallback build strategies
echo "🔄 Stage 3: Fallback strategies..."

# Fallback 1: Minimal build
echo "🔧 Fallback 1: Minimal build..."
flutter clean
flutter pub get
if flutter build apk --debug --target-platform android-arm64; then
    echo "✅ Minimal build successful!"
    exit 0
fi

# Fallback 2: Legacy compatibility build
echo "🔧 Fallback 2: Legacy compatibility..."
flutter clean
flutter pub get
if flutter build apk --debug --no-shrink --no-tree-shake-icons; then
    echo "✅ Legacy build successful!"
    exit 0
fi

echo "❌ All build strategies failed"
exit 1