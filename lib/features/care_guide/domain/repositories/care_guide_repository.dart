
import '../model/care_guide.dart';
import '../../../plants/domain/model/plant.dart';

abstract class CareGuideRepository {
  /// General guide when [plant] is null, otherwise personalised to that plant.
  CareGuide guideFor(Plant? plant);
}

