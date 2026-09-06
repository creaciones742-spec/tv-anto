#!/bin/bash
echo "Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"
echo "Building Flutter Web application..."
flutter build web --release
echo "Build completed successfully!"
