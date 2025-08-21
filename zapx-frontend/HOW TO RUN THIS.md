INSTALL THE FIRST TIME

1. flutter pub get (install dependencies)
2. cd ios && pod install (install iOS CocoaPods dependencies)
3. cd .. (return to project root)
4. open -a Simulator
5. flutter run -d "iPhone 16 Pro" (run the app on iOS simulator)

OR

JUST RUN:

1. open -a Simulator
2. flutter run -d "iPhone 16 Pro"

Flutter Clean + Fresh Install

1. cd zapx-frontend
2. flutter clean
3. flutter pub get
4. flutter run -d "iPhone 16 Pro"

Delete App from Simulator

1. Long press the ZapX app icon on simulator home screen
2. Tap "Remove App" → "Delete App"
3. Then run flutter run -d "iPhone 16 Pro" again

📊 Created Users:

👑 ADMIN Users: admin@example.com, superadmin@zapx.com, platform@zapx.com

🛒 CONSUMER Users: sarah.jones@example.com, mike.chen@example.com, emily.davis@example.com

📸 SELLER Users: alex.photo@example.com, jessica.video@example.com, david.studio@example.com, maria.films@example.com

🔑 Default passwords:

- Admin: admin123 / superadmin123 / platform123
- Consumer: consumer123
- Seller: seller123

## 🔧 Development Configuration

The app automatically detects the environment and uses the appropriate backend URL:

- **Debug Mode** (development): `http://localhost:5003`
- **Release Mode** (production): `https://saboia.xyz`

When running `flutter run` in development, the app will connect to your local backend server. Make sure your backend is running on port 5003:

```bash
cd backend
npm run dev
```

If you want to test against the production server while in development, you can temporarily modify `/lib/configs/app_url.dart`.
