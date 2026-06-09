import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/sewatani_app.dart';
import 'providers/alat_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AlatProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const SewaTaniApp(),
    ),
  );
}
