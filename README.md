
A small GetX-friendly Shimmer widget for Flutter.


<p>
    <img src="https://github.com/HsnAlidroos/get_shimmer/blob/main/screenshots/loading_list.gif?raw=true"/>
     <img src="https://github.com/HsnAlidroos/get_shimmer/blob/main/screenshots/loading_list_with_move.gif?raw=true"/>
</p>

This package provides a lightweight Shimmer widget built using `Getx` for
controller lifecycle and simple configuration. It uses a `ShaderMask` under the
hood to render an animated gradient over a child widget.

## Features

Features
- Shimmer effect using `ShaderMask` and `AnimationController`.
- Uses `Get.put` for controller lifecycle, keeping widget code concise.

## Getting started

Getting started

Add `get_shimmer` to your `pubspec.yaml` and import it:

```dart
import 'package:get_shimmer/get_shimmer.dart';
```

## Usage

Usage example

```dart
// Using the convenience constructor demonstrated in the example
GetShimmer.fromColors(
   // baseColor: Colors.grey.shade300, 
   // highlightColor: Colors.grey.shade100, 
    child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.white,
        ),
);
```

Tip: set `enabled: false` to show the static placeholder without animation (useful
in tests or when you want to conditionally disable shimmer).

```dart
const like = 'sample';
```

## Additional information

Contributing

Contributions are welcome. Please open issues or PRs on the repository.
# get_shimmer
