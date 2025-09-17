# Eshtry-menny 🛒

Eshtry-menny is a modern Flutter e-commerce application that provides a seamless shopping experience with a clean, intuitive interface. The app features comprehensive product browsing, cart management, favorites, and user authentication.

## ✨ Features

### 🔐 Authentication
- User registration and sign-in functionality
- Secure authentication system using BLoC pattern
- Session management

### 🏪 Shopping Experience
- Browse products from FakeStore API
- Product categories and filtering
- Detailed product views with images and descriptions
- Search functionality

### 🛍️ Cart & Favorites
- Add/remove items to/from shopping cart
- Quantity management
- Favorites/wishlist functionality
- Checkout process with order summary
- Order success confirmation

### 📱 User Interface
- Modern Material Design UI
- Dark theme support
- Responsive design for different screen sizes
- Custom app bar and navigation
- Bottom navigation bar
- Toast notifications

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/Eshtry-menny.git
   cd Eshtry-menny
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Credentials
For testing purposes, you can use:
- **Username:** `mor_2314`
- **Password:** `83r5^_`

## 🏗️ Architecture

The app follows a clean architecture pattern with:

- **BLoC Pattern**: State management using flutter_bloc
- **Feature-based Structure**: Organized by features (auth, home, cart, favorites)
- **Separation of Concerns**: Clear separation between UI, business logic, and data

### Project Structure
```
lib/
├── core/
│   ├── constants/     # App constants and colors
│   ├── services/      # API services
│   ├── theme/         # App theming
│   └── widgets/       # Reusable widgets
├── features/
│   ├── auth/          # Authentication feature
│   ├── cart/          # Shopping cart feature
│   ├── favorites/     # Favorites/wishlist feature
│   └── home/          # Home and product browsing
└── main.dart          # App entry point
```

## 📦 Dependencies

### Core Dependencies
- **flutter_bloc** (^9.0.0) - State management
- **http** (^1.3.0) - HTTP requests
- **sqflite** (^2.4.1) - Local database
- **sizer** (^3.0.5) - Responsive design

### UI Dependencies
- **flutter_svg** (^2.0.17) - SVG support
- **fluttertoast** (^8.2.12) - Toast notifications
- **cupertino_icons** (^1.0.8) - iOS-style icons

### Utilities
- **equatable** (^2.0.7) - Value equality
- **path** (^1.9.0) - Path manipulation

## 🌐 API Integration

The app integrates with the [FakeStore API](https://fakestoreapi.com/) to fetch:
- Product listings
- Product categories
- Product details
- User authentication

## 🎨 Theming

The app supports:
- Dark theme as default
- Custom color scheme
- Consistent Material Design components
- Responsive typography

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

If you have any questions or issues, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**
