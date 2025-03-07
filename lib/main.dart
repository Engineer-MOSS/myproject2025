import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './app_data.dart';
import './models/trip.dart';
import './screens/category_trips_screen.dart';
import './screens/filters_screen.dart';
import './screens/tabs_screen.dart';
import './screens/trip_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'summer': false,
    'winter': false,
    'family': false,
  };

  List<Trip> _availableTrips = Trips_data;
  List<Trip> _favoriteTrips = [];

  void _changeFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _availableTrips = Trips_data.where((trip) {
        if (_filters['summer'] == true && trip.isInSummer != true) {
          return false;
        }
        if (_filters['winter'] == true && trip.isInWinter != true) {
          return false;
        }
        if (_filters['family'] == true && trip.isForFamilies != true) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _manageFavorite(String tripId) {
    final existingIndex = _favoriteTrips.indexWhere(
      (trip) => trip.id == tripId,
    );
    if (existingIndex >= 0) {
      setState(() {
        _favoriteTrips.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteTrips.add(Trips_data.firstWhere(
          (trip) => trip.id == tripId,
        ));
      });
    }
  }

  bool _isFavorite(String id) {
    return _favoriteTrips.any(
      (trip) => trip.id == id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'AE'), // English
      ],
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          primarySwatch: Colors.amber,
          useMaterial3: true,
          fontFamily: "Lato-Bold",
          textTheme: ThemeData.light().textTheme.copyWith(
              headlineMedium: TextStyle(
                color: Colors.teal,
                fontSize: 24,
                fontFamily: "Lato-Bold",
                fontWeight: FontWeight.bold,
              ),
              headlineLarge: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontFamily: "Lato-Bold",
                fontWeight: FontWeight.bold,
              ))),
      //home: CategoriesScreen(),
      initialRoute: '/', //تعيين المسار الاولي للتطبيق
      routes: {
        '/': (ctx) => TabsScreen(_favoriteTrips),
        CategoryTripsScreen.screenRoute: (ctx) =>
            CategoryTripsScreen(_availableTrips),
        TripDetailScreen.screenRoute: (ctx) =>
            TripDetailScreen(_manageFavorite, _isFavorite),
        FiltersScreen.screenRout: (ctx) =>
            FiltersScreen(_filters, _changeFilters),
      },
    );
  }
}
