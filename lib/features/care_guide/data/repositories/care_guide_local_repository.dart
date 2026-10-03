import '../../domain/model/care_guide.dart';
import '../../domain/repositories/care_guide_repository.dart';
import '../../../plants/domain/model/plant.dart';

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
    'সপ্তাহে অন্তত একবার গাছটা একটু ঘুরিয়ে দিন, যেন চারপাশেই সমান আলো পায় আর সোজা হয়ে বাড়ে।',
    'শিকড় পচা থেকে বাঁচাতে আবার পানি দেওয়ার আগে টবের ওপরের ১ ইঞ্চি মাটি শুকানোর সুযোগ দিন।',
    'গাছকে শান্তিতে নিঃশ্বাস নিতে দিন! মাসে অন্তত একবার ভেজা কাপড়ে পাতাগুলো যত্ন করে মুছে দিন।',
    '১২–১৮ মাস পর পর গাছকে নতুন ঘর দিন—বর্তমান টবের চেয়ে মাত্র এক সাইজ বড় টবে শিফট করুন।',
  ];

  static const _problems = [
    CommonProblem(
      ProblemKind.yellowLeaves,
      'Yellow leaves',
      'Usually overwatering. Let soil dry out more between waterings.',
    ),
    CommonProblem(
      ProblemKind.brownTips,
      'Brown, crispy tips',
      'Low humidity or too much direct sun. Mist leaves or move away from windows.',
    ),
    CommonProblem(
      ProblemKind.drooping,
      'Drooping stems',
      'Thirsty plant or shock from a recent move. Water thoroughly and give it a few days.',
    ),
  ];

  static const _problemsBn = [
    CommonProblem(
      ProblemKind.yellowLeaves,
      'পাতা হলুদ হয়ে যাওয়া',
      'অতিরিক্ত ভালোবাসার (পানি!) ফল। আবার পানি দেওয়ার আগে মাটি একটু শুকাতে দিন।',
    ),
    CommonProblem(
      ProblemKind.brownTips,
      'পাতার ডগা শুকিয়ে বাদামী হওয়া',
      'বাতাসে আর্দ্রতা কম বা চড়া রোদ লেগেছে। পাতায় হালকা পানি স্প্রে করুন বা জানালা থেকে কিছুটা সরিয়ে রাখুন।',
    ),
    CommonProblem(
      ProblemKind.drooping,
      'গাছ বা ডালপালা নেতিয়ে পড়া',
      'গাছটি ভীষণ তৃষ্ণার্ত, নাকি নতুন জায়গায় এসে খাপ খাওয়াতে পারছে না? পেট ভরে পানি দিন, দু-একদিনেই চাঙ্গা হয়ে উঠবে!',
    ),
  ];

  String _or(String v) => v.trim().isEmpty ? '—' : v;

  /// "Every 5 days" from the plant's own watering interval.
  String _waterEvery(Plant p, bool isBn) => isBn
      ? 'প্রতি ${p.wateringFrequencyDays} দিনে'
      : 'Every ${p.wateringFrequencyDays} days';

  /// When the next watering is due, from the real date.
  String _waterDue(Plant p, bool isBn) {
    final d = p.waterDueInDays;
    if (d == null) return '—';
    if (d < 0) return isBn ? '${-d} দিন দেরি' : 'overdue by ${-d} days';
    if (d == 0) return isBn ? 'আজ' : 'today';
    if (d == 1) return isBn ? 'আগামীকাল' : 'tomorrow';
    return isBn ? '$d দিন পরে' : 'in $d days';
  }

  @override
  CareGuide guideFor(Plant? p) {
    final isBn = getLanguage?.call() == 'bn';

    return CareGuide(
      title: p?.nickname ??
          (isBn ? 'গাছের যত্নআত্তির এ-টু-জেড' : 'Plant Care 101'),
      species: p?.species ??
          (isBn ? 'সাধারণ ইনডোর প্ল্যান্ট' : 'Category – General Houseplant'),
      water: p == null
          ? (isBn ? 'সপ্তাহে ২ দিন' : 'Twice a week')
          : _waterEvery(p, isBn),
      sunlight: p == null
          ? (isBn ? 'মিষ্টি রোদ বা পরোক্ষ আলো' : 'Bright indirect light')
          : _or(p.sunlight),
      temperature: '20°C – 28°C',
      fertilizer: p == null
          ? (isBn ? 'প্রতি ২ সপ্তাহে একবার' : 'Every 2 weeks')
          : _or(p.fertilizerNote),
      humidity: p == null ? '60%' : _or(p.humidity),
      dailyTasks: [
        DailyCareTask(
          DailyTaskKind.moisture,
          p == null
              ? (isBn ? 'মাটি ভেজা নাকি শুকনো দেখে নিন' : 'Check soil moisture')
              : '${isBn ? 'পানি' : 'Water'}: ${_waterDue(p, isBn)}',
        ),
        DailyCareTask(
          DailyTaskKind.light,
          p == null
              ? (isBn
                  ? 'পর্যাপ্ত আলো পাচ্ছে তো? পরখ করুন'
                  : "Make sure it's getting enough light")
              : '${isBn ? 'সূর্যালোক' : 'Sunlight'}: ${_or(p.sunlight)}',
        ),
        DailyCareTask(
          DailyTaskKind.mist,
          isBn ? 'পাতায় হালকা পানি স্প্রে করুন' : 'Mist the leaves',
        ),
        DailyCareTask(
          DailyTaskKind.dust,
          isBn ? 'পাতার ধুলোবালি মুছে সাফ করে দিন' : 'Wipe dust off the leaves',
        ),
        DailyCareTask(
          DailyTaskKind.pests,
          isBn
              ? 'পোকা-মাকড় বা হলুদ পাতার ওপর নজর রাখুন'
              : 'Look for pests or yellow leaves',
        ),
      ],
      proTips: isBn ? _tipsBn : _tips,
      problems: isBn ? _problemsBn : _problems,
    );
  }
}