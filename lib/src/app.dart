import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:jobber/src/core/models/positions.dart';
import 'package:jobber/src/core/services/location_service.dart';
import 'package:jobber/src/ui/theme/theme.dart';
import 'package:jobber/src/ui/screens/home.dart';

import 'package:provider/provider.dart';

class JobberApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = buildTheme();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return StreamProvider.value(
      value: LocationService().locationStream,
      child: Consumer<UserLocation>(
        builder: (context, model, _) => ChangeNotifierProvider(
          builder: (context) => Positions(context),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pambe jobs',
            theme: theme,
            home: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                systemNavigationBarColor: theme.colorScheme.background,
              ),
              child: Home(),
            ),
          ),
        ),
      ),
    );
  }
}
