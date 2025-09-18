# Eshtry-menny 🛒

Eshtry-menny is a modern Flutter e-commerce application that provides a seamless shopping experience with a clean, intuitive interface. The app features comprehensive product browsing, cart management, favorites, and user authentication.

## 📱 Screens
<img width="426" height="952" alt="Screenshot_1758153223" src="https://github.com/user-attachments/assets/79b0b216-fdd9-473b-b608-38b64b40bbfd" />
<img width="426" height="952" alt="Screenshot_1758153213" src="https://github.com/user-attachments/assets/07b46c32-7b06-4ff6-995f-0388097ea2c8" />
<img width="426" height="952" alt="Screenshot_1758153205" src="https://github.com/user-attachments/assets/d151289d-528a-49bd-9297-ce9e949599ba" />
<img width="426" height="952" alt="Screenshot_1758153201" src="https://github.com/user-attachments/assets/8bf59e10-1045-499c-827f-44681b64f100" />
<img width="426" height="952" alt="Screenshot_1758153197" src="https://github.com/user-attachments/assets/0dea57a4-7c57-453c-ace2-1a58e043d4e7" />
<img width="426" height="952" alt="Screenshot_1758153186" src="https://github.com/user-attachments/assets/80d52ca8-d09a-4535-a889-949ce77e410c" />
<img width="426" height="952" alt="Screenshot_1758152863" src="https://github.com/user-attachments/assets/d062b3c3-da39-4fe2-9075-1a295c4fe7df" />


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


**Built with ❤️ using Flutter**
