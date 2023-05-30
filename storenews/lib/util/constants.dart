import 'package:flutter/material.dart';

const appName = "Store News";
// -- News fetching -- //
// When news for the same store is fetched again
const beaconNewsFetchInterval = Duration(minutes: 30);
const notificationCoolDown = Duration(minutes: 5);
const storeNewsCount = 10; // How many news items to fetch for a store

// -- Beacon Scanning -- //
const enableBeaconPluginDebug = false;
const beaconRegionName = "StoreNewsBeacons";
const beaconRegionUUID = "acfd065e-c3c0-11e3-9bbe-1a514932ac01";
const beaconRecognitionDistance = 3.0; // in meters
const beaconForegroundScanPause = Duration(seconds: 10);
const beaconBackgroundScanPause = Duration(seconds: 30);
const beaconScanDuration = Duration(seconds: 5);

// -- API Endpoints -- //
const apiBaseUrl = "http://192.168.0.25:8080";
const tokenEndpoint = "/auth/customertoken";

// -- UI -- //
class InsetSizes {
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
}

class BorderSizes {
  static const circularRadius = 10.0;
}

// Generated using https://m3.material.io/theme-builde
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF285EA7),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD6E3FF),
  onPrimaryContainer: Color(0xFF001B3D),
  secondary: Color(0xFF555F71),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD9E3F9),
  onSecondaryContainer: Color(0xFF121C2B),
  tertiary: Color(0xFF6F5675),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFF9D8FD),
  onTertiaryContainer: Color(0xFF28132F),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFDFBFF),
  onBackground: Color(0xFF1A1B1E),
  surface: Color(0xFFFDFBFF),
  onSurface: Color(0xFF1A1B1E),
  surfaceVariant: Color(0xFFE0E2EC),
  onSurfaceVariant: Color(0xFF44474E),
  outline: Color(0xFF74777F),
  onInverseSurface: Color(0xFFF1F0F4),
  inverseSurface: Color(0xFF2F3033),
  inversePrimary: Color(0xFFA9C7FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF285EA7),
  outlineVariant: Color(0xFFC4C6CF),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFA9C7FF),
  onPrimary: Color(0xFF003063),
  primaryContainer: Color(0xFF00468C),
  onPrimaryContainer: Color(0xFFD6E3FF),
  secondary: Color(0xFFBDC7DC),
  onSecondary: Color(0xFF283141),
  secondaryContainer: Color(0xFF3E4758),
  onSecondaryContainer: Color(0xFFD9E3F9),
  tertiary: Color(0xFFDCBCE1),
  onTertiary: Color(0xFF3F2845),
  tertiaryContainer: Color(0xFF563E5C),
  onTertiaryContainer: Color(0xFFF9D8FD),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1A1B1E),
  onBackground: Color(0xFFE3E2E6),
  surface: Color(0xFF1A1B1E),
  onSurface: Color(0xFFE3E2E6),
  surfaceVariant: Color(0xFF44474E),
  onSurfaceVariant: Color(0xFFC4C6CF),
  outline: Color(0xFF8E9099),
  onInverseSurface: Color(0xFF1A1B1E),
  inverseSurface: Color(0xFFE3E2E6),
  inversePrimary: Color(0xFF285EA7),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFA9C7FF),
  outlineVariant: Color(0xFF44474E),
  scrim: Color(0xFF000000),
);
