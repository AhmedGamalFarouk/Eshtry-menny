# Eshtry-menny 🛒

Eshtry-menny is a modern Flutter e-commerce application that provides a seamless shopping experience with a clean, intuitive interface. The app features comprehensive product browsing, category filtering, cart management, favorites, and user authentication.

## 📱 Screens

<p align="center">
  <img width="213" alt="Screenshot 1" src="https://github.com/user-attachments/assets/79b0b216-fdd9-473b-b608-38b64b40bbfd" />
  <img width="213" alt="Screenshot 2" src="https://github.com/user-attachments/assets/07b46c32-7b06-4ff6-995f-0388097ea2c8" />
  <img width="213" alt="Screenshot 3" src="https://github.com/user-attachments/assets/d151289d-528a-49bd-9297-ce9e949599ba" />
  <img width="213" alt="Screenshot 4" src="https://github.com/user-attachments/assets/8bf59e10-1045-499c-827f-44681b64f100" />
</p>
<p align="center">
  <img width="213" alt="Screenshot 5" src="https://github.com/user-attachments/assets/0dea57a4-7c57-453c-ace2-1a58e043d4e7" />
  <img width="213" alt="Screenshot 6" src="https://github.com/user-attachments/assets/80d52ca8-d09a-4535-a889-949ce77e410c" />
  <img width="213" alt="Screenshot 7" src="https://github.com/user-attachments/assets/d062b3c3-da39-4fe2-9075-1a295c4fe7df" />
</p>

## ✨ Features

### 🔐 Authentication
- User registration and sign-in functionality
- State-managed authentication flow using BLoC/Cubit
- One-tap demo test login

### 🏪 Shopping Experience
- Browse products integrated with [FakeStore API](https://fakestoreapi.com/)
- Product categories and synchronized real-time search
- Detailed product views with image gallery, ratings, and descriptions

### 🛍️ Cart & Favorites
- Add and remove items to/from shopping cart
- Local persistence with SQLite
- Quantity management and live price calculation
- Wishlist / favorites functionality persisted locally across sessions
- Checkout flow with order confirmation

### 📱 User Interface
- Modern Material Design dark theme
- Responsive layout across various screen sizes using Sizer
- High-performance image caching with `cached_network_image`
- Interactive animations and haptic feedback
- Floating toast notifications

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AhmedGamalFarouk/Eshtry-menny.git
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
*(or tap the "Test Login" button on the Sign-In screen)*

## 🏗️ Architecture

- **BLoC Pattern**: State management using `flutter_bloc`
- **Feature-based Structure**: Organized by feature domains (`auth`, `home`, `cart`, `favorites`)
- **Persistence**: Local SQLite database for both cart and favorites

### Project Structure
```
lib/
├── core/
│   ├── constants/     # App colors and design tokens
│   ├── services/      # Local database helper (SQLite)
│   ├── theme/         # Application theme configuration
│   └── widgets/       # Shared UI components
├── features/
│   ├── auth/          # Authentication screens and cubits
│   ├── cart/          # Cart and checkout screens and cubits
│   ├── favorites/     # Favorites/wishlist screens and cubits
│   └── home/          # Discovery, search, and product details
└── main.dart          # Application entry point
```

## 📦 Key Dependencies

- **flutter_bloc** - State management
- **http** - HTTP requests to FakeStore API
- **sqflite** & **path** - Local SQLite database
- **cached_network_image** - Image caching and memory management
- **sizer** - Responsive sizing engine
- **equatable** - Value equality for BLoC states
- **fluttertoast** - Toast feedback

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using Flutter**
