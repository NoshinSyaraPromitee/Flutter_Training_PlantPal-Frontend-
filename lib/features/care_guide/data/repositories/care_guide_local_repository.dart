import '../../domain/entities/care_guide.dart';
import '../../domain/repositories/care_guide_repository.dart';
import '../../../plants/domain/entities/plant.dart';

class CareGuideLocalRepository implements CareGuideRepository {
  CareGuideLocalRepository({this.getLanguage});
  final String Function()? getLanguage;

  static const _tips = [
    'Rotate your plant a quarter turn every week so it grows evenly toward the light.',
    'Let the top inch of soil dry out before watering again to avoid root rot.',
    'Wipe leaves with a damp cloth monthly so they can breathe and photosynthesize better.',
    'Repot every 12–18 months into a pot just one size larger than the current one.',
  ];

  static const _tipsBn = [
    'প্রতি সপ্তাহে আপনার গাছকে এক-চতুর্থাংশ ঘুরিয়ে দিন যাতে এটি আলোর দিকে সমানভাবে বাড়ে।',
    'মূল বা শিকড় পচা রোধ করতে পুনরায় পানি দেওয়ার আগে মাটির ওপরের এক ইঞ্চি শুকাতে দিন।',
    'গাছ যাতে সহজে শ্বাস নিতে পারে সেজন্য প্রতি মাসে ভেজা নরম কাপড় দিয়ে পাতা মুছে নিন।',
    'প্রতি ১২–১৮ মাস পর পর বর্তমান টবের চেয়ে মাত্র এক সাইজ বড় টবে গাছ স্থানান্তর করুন।',
  ];

  static const _problems = [
    CommonProblem(ProblemKind.yellowLeaves, 'Yellow leaves', 'Usually overwatering. Let soil dry out more between waterings.'),
    CommonProblem(ProblemKind.brownTips, 'Brown, crispy tips', 'Low humidity or too much direct sun. Mist leaves or move away from windows.'),
    CommonProblem(ProblemKind.drooping, 'Drooping stems', 'Thirsty plant or shock from a recent move. Water thoroughly and give it a few days.'),
  ];

  static const _problemsBn = [
    CommonProblem(ProblemKind.yellowLeaves, 'হলুদ পাতা', 'সাধারণত অতিরিক্ত পানির কারণে হয়। পরবর্তী পানি দেওয়ার আগে মাটি ভালোভাবে শুকাতে দিন।'),
    CommonProblem(ProblemKind.brownTips, 'বাদামী ও শুষ্ক পাতার ডগা', 'কম আর্দ্রতা বা অতিরিক্ত সরাসরি রোদ। পাতায় পানি স্প্রে করুন বা জানালা থেকে কিছুটা দূরে সরিয়ে নিন।'),
    CommonProblem(ProblemKind.drooping, 'ঝুলে পড়া কাণ্ড', 'পানির অভাব বা স্থান পরিবর্তনের ধাক্কা। পর্যাপ্ত পানি দিন এবং কয়েক দিন সময় দিন।'),
  ];

  String _or(String v) => v.trim().isEmpty ? '—' : v;

  @override
  CareGuide guideFor(Plant? p) {
    final isBn = getLanguage?.call() == 'bn';
    return CareGuide(
      title: p?.nickname ?? (isBn ? 'গাছের প্রাথমিক পরিচর্যা' : 'Plant Care 101'),
      species: p?.species ?? (isBn ? 'সাধারণ ইনডোর গাছ' : 'Category – General Houseplant'),
      water: p?.waterLevel ?? (isBn ? 'সপ্তাহে দুইবার' : 'Twice a week'),
      sunlight: p == null ? (isBn ? 'পর্যাপ্ত পরোক্ষ আলো' : 'Bright indirect light') : _or(p.sunlight),
      temperature: '20°C – 28°C',
      fertilizer: p == null ? (isBn ? 'প্রতি ২ সপ্তাহে একবার' : 'Every 2 weeks') : _or(p.fertilizerNote),
      humidity: p == null ? '60%' : _or(p.humidity),
      dailyTasks: [
        DailyCareTask(DailyTaskKind.moisture, p == null ? (isBn ? 'মাটির আর্দ্রতা পরীক্ষা করুন' : 'Check soil moisture') : '${isBn ? 'পানি' : 'Water'}: ${p.waterLevel}'),
        DailyCareTask(DailyTaskKind.light, p == null ? (isBn ? 'পর্যাপ্ত আলো পাচ্ছে কিনা নিশ্চিত করুন' : "Make sure it's getting enough light") : '${isBn ? 'সূর্যালোক' : 'Sunlight'}: ${_or(p.sunlight)}'),
        DailyCareTask(DailyTaskKind.mist, isBn ? 'পাতায় পানি স্প্রে করুন' : 'Mist the leaves'),
        DailyCareTask(DailyTaskKind.dust, isBn ? 'পাতা থেকে ধুলোবালি মুছে ফেলুন' : 'Wipe dust off the leaves'),
        DailyCareTask(DailyTaskKind.pests, isBn ? 'কীটপতঙ্গ বা হলুদ পাতা লক্ষ্য করুন' : 'Look for pests or yellow leaves'),
      ],
      proTips: isBn ? _tipsBn : _tips,
      problems: isBn ? _problemsBn : _problems,
    );
  }
}