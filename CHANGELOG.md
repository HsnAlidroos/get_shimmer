## 0.0.8
* 🔧 **Breaking fix**: Replaced custom `RenderProxyBox` with Flutter's native `ShaderMask`
  - Fixes `OffsetLayer` type casting errors
  - Eliminates layer composition conflicts
  - More stable and maintainable
* 🧹 Simplified `GetShimmerController` using `GetSingleTickerProviderStateMixin`
* 📉 Reduced code complexity (~60 lines removed)
* 🗑️ Removed unused `flutter/rendering.dart` import

## 0.0.7
* ⚡ Performance optimizations:
  - Shader caching to reduce GPU work per frame
  - Proper ticker disposal to prevent memory leaks
  - RepaintBoundary for isolated repaints
* 🔄 Multiple shimmer instances now animate independently (unique controller tags)
* 🚀 Zero overhead when `enabled: false` (returns child directly)
* 🎨 Default colors changed from blue to grey shades (grey.shade300/100)
* 📦 Updated `get` dependency to ^4.7.3
* 📖 Updated README and preview images

## 0.0.6
* Made default values of baseColor and highlightColor and nullable for them.

## 0.0.5
* Add Images to README.md file.

## 0.0.4
* Update README.md file.

## 0.0.3
* Add Example.

## 0.0.2
* Initial release.

## 0.0.1
* Initial test.