import 'package:go_router/go_router.dart';
import 'package:plantpal/features/ai_doctor/presentation/screens/scan_plant_screen.dart';
import 'package:plantpal/features/care_guide/presentation/screens/care_guide_screen.dart';
import 'package:plantpal/features/fertilizer/presentation/screens/add_fertilizer_screen.dart';
import 'package:plantpal/features/fertilizer/presentation/screens/fertilizer_details_screen.dart';
import 'package:plantpal/features/fertilizer/presentation/screens/fertilizer_screen.dart';
import 'package:plantpal/features/plants/presentation/screens/add_plant_screen.dart';
import 'package:plantpal/features/plants/presentation/screens/care_calendar_screen.dart';
import 'package:plantpal/features/plants/presentation/screens/edit_plant_screen.dart';
import 'package:plantpal/features/plants/presentation/screens/my_plants_screen.dart';
import 'package:plantpal/features/plants/presentation/screens/plant_details_screen.dart';
import 'package:plantpal/features/plants/presentation/screens/plant_history_screen.dart';

/// Plant management, care calendar, care guide and fertilizer routes.
final plantRoutes = <RouteBase>[
  GoRoute(
    path: '/plants',
    builder: (c, s) => const MyPlantsScreen(),
    routes: [
      GoRoute(
        path: 'add',
        builder: (c, s) => AddPlantScreen(
          startWithScan: s.uri.queryParameters['scan'] == '1',
        ),
      ),
      GoRoute(
        path: ':id',
        builder: (c, s) => PlantDetailsScreen(plantId: s.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (c, s) => EditPlantScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'scan',
            builder: (c, s) => ScanPlantScreen(plantId: s.pathParameters['id']!),
          ),
        ],
      ),
    ],
  ),
  GoRoute(path: '/care-calendar', builder: (c, s) => const CareCalendarScreen()),
  GoRoute(path: '/plant-history', builder: (c, s) => const PlantHistoryScreen()),
  GoRoute(
    path: '/care-guide',
    builder: (c, s) => CareGuideScreen(plantId: s.uri.queryParameters['plantId']),
  ),
  GoRoute(
    path: '/fertilizer',
    builder: (c, s) => const FertilizerScreen(),
    routes: [
      GoRoute(path: 'add', builder: (c, s) => const AddFertilizerScreen()),
      GoRoute(
        path: ':id',
        builder: (c, s) => FertilizerDetailsScreen(id: s.pathParameters['id']!),
      ),
    ],
  ),
];

