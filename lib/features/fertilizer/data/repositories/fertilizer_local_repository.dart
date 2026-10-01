import '../../domain/model/fertilizer.dart';
import '../../domain/repositories/fertilizer_repository.dart';

class FertilizerLocalRepository implements FertilizerRepository {
  FertilizerLocalRepository({this.getLanguage});

  final String Function()? getLanguage;

  @override
  Future<FertilizerCatalog> getCatalog() async {
    final isBn = getLanguage?.call() == 'bn';

    return FertilizerCatalog(
      items: isBn ? _itemsBn : _items,
      safetyTips: isBn ? _tipsBn : _tips,
    );
  }

  static const _tips = [
    'Avoid using fertilizers on very young seedlings.',
    'Do not overapply homemade fertilizers, as excess nutrients can harm plants.',
    'Dilute liquid fertilizers before use whenever recommended.',
    'Store homemade fertilizers in covered containers away from children and pets.',
    'Use only well-decomposed organic materials to reduce odor and the risk of plant diseases.',
  ];

  static const _tipsBn = [
    'খুব ছোট চারায় সার প্রয়োগ করবেন না।',
    'অতিরিক্ত সার ব্যবহার করবেন না, কারণ অতিরিক্ত পুষ্টি গাছের ক্ষতি করতে পারে।',
    'তরল সার ব্যবহারের পূর্বে নির্দেশ অনুযায়ী পানি মিশিয়ে পাতলা করে নিন।',
    'ঘরে তৈরি সার শিশু ও পোষা প্রাণীদের নাগালের বাইরে ঢেকে রাখুন।',
    'দুর্গন্ধ ও রোগবালাই এড়াতে কেবল ভালোভাবে পচে যাওয়া জৈব উপাদান ব্যবহার করুন।',
  ];

  static const _items = <Fertilizer>[
    Fertilizer(
      id: '1',
      name: 'Banana Peel Fertilizer',
      purpose: 'Flowering & Fruit Production',
      nutrient: 'Potassium',
      imageUrl:
          'https://www.littlepassports.com/wp-content/uploads/2021/04/7a3de644-banana-peel-fertilizer.jpg',
      ingredients: ['2–3 banana peels', '1 liter water'],
      preparation: [
        'Cut the peels into small pieces.',
        'Soak them in water for 24–48 hours.',
        'Strain the liquid.',
      ],
      application: 'Water plants once every week.',
      benefits: [
        'Rich in potassium.',
        'Encourages flowering and fruit production.',
      ],
    ),
    Fertilizer(
      id: '2',
      name: 'Eggshell Fertilizer',
      purpose: 'Calcium Boost',
      nutrient: 'Calcium',
      imageUrl:
          'https://tse1.mm.bing.net/th/id/OIP.N5gX1ngWgwBGNYgc2Q2zpQHaEK?r=0&w=1024&h=576&rs=1&pid=ImgDetMain&o=7&rm=3',
      ingredients: ['5–6 eggshells'],
      preparation: [
        'Wash the shells.',
        'Dry them completely.',
        'Grind into a fine powder.',
      ],
      application: 'Sprinkle around the plant base every month.',
      benefits: [
        'Supplies calcium.',
        'Prevents calcium deficiency.',
      ],
    ),
    Fertilizer(
      id: '3',
      name: 'Rice Wash Water Fertilizer',
      purpose: 'Root Growth',
      nutrient: 'Vitamins & Minerals',
      imageUrl:
          'https://tse3.mm.bing.net/th/id/OIP.Tif-sUvxKoHxgIwsHcFImwHaGz?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
      ingredients: ['Water used for washing rice'],
      preparation: [
        'Collect the first or second rinse water.',
      ],
      application: 'Use immediately to water plants.',
      benefits: [
        'Contains vitamins, minerals, and starch.',
        'Supports healthy root growth.',
      ],
    ),
    Fertilizer(
      id: '4',
      name: 'Tea Leaf Compost',
      purpose: 'Soil Improvement',
      nutrient: 'Organic Matter',
      imageUrl:
          'https://earthcrew.com/wp-content/uploads/2023/11/Tea-Leaf-Compost.jpg',
      ingredients: ['Used tea leaves (without sugar or milk)'],
      preparation: [
        'Wash if necessary.',
        'Dry before use.',
      ],
      application: 'Mix into the soil.',
      benefits: [
        'Adds organic matter.',
        'Improves soil texture.',
      ],
    ),
    Fertilizer(
      id: '5',
      name: 'Vegetable Peel Compost',
      purpose: 'Balanced Soil Fertility',
      nutrient: 'Balanced Nutrients',
      imageUrl:
          'https://plantly.io/wp-content/uploads/2023/02/Untitled-design-4-1-1536x1024.jpg',
      ingredients: ['Vegetable peels', 'Dry leaves', 'Soil'],
      preparation: [
        'Layer vegetable peels and dry leaves.',
        'Cover with soil.',
        'Compost for 30–45 days.',
      ],
      application: 'Mix compost into garden soil.',
      benefits: [
        'Provides balanced nutrients.',
        'Improves soil fertility.',
      ],
    ),
    Fertilizer(
      id: '6',
      name: 'Mustard Cake Fertilizer',
      purpose: 'Leafy Growth',
      nutrient: 'Nitrogen',
      imageUrl:
          'https://organicbazar.net/cdn/shop/products/Mustard-Cake.jpg?v=1694167824&width=1946',
      ingredients: ['100 g mustard oil cake', '2 liters water'],
      preparation: [
        'Soak for 2–3 days.',
        'Dilute with equal amount of water before use.',
      ],
      application: 'Apply every 15–20 days.',
      benefits: [
        'Rich in nitrogen.',
        'Promotes leafy growth.',
      ],
    ),
    Fertilizer(
      id: '7',
      name: 'Wood Ash Fertilizer',
      purpose: 'Flowering Support',
      nutrient: 'Potassium & Calcium',
      imageUrl:
          'https://www.myearthgarden.com/wp-content/uploads/2025/10/wood-ash-fertilizer.jpeg',
      ingredients: ['Clean wood ash (no charcoal or chemicals)'],
      preparation: ['Collect cooled ash.'],
      application: 'Sprinkle a small amount around plants.',
      benefits: [
        'Rich in potassium and calcium.',
        'Helps flowering.',
      ],
    ),
    Fertilizer(
      id: '8',
      name: 'Onion Peel Fertilizer',
      purpose: 'Micronutrient Boost',
      nutrient: 'Micronutrients',
      imageUrl:
          'https://i.ytimg.com/vi/EIqcmOFKLC8/maxresdefault.jpg',
      ingredients: ['Onion peels', '1 liter water'],
      preparation: [
        'Soak peels for 24 hours.',
        'Strain the liquid.',
      ],
      application: 'Water plants every two weeks.',
      benefits: [
        'Provides micronutrients.',
        'Supports healthy plant growth.',
      ],
    ),
    Fertilizer(
      id: '9',
      name: 'Fish Waste Fertilizer',
      purpose: 'Vigorous Growth',
      nutrient: 'Nitrogen & Phosphorus',
      imageUrl:
          'https://hakaimagazine.com/wp-content/uploads/header-fisheries-waste-to-wealth-1536x738.jpg',
      ingredients: [
        'Fish scales or fish waste',
        'Water',
        'Airtight container',
      ],
      preparation: [
        'Place fish waste in the container.',
        'Add water.',
        'Ferment for about 2 weeks.',
        'Dilute before use (1:10 with water).',
      ],
      application: 'Apply once every 2–3 weeks.',
      benefits: [
        'High in nitrogen and phosphorus.',
        'Encourages vigorous growth.',
      ],
    ),
    Fertilizer(
      id: '10',
      name: 'Cow Dung Liquid Fertilizer',
      purpose: 'Balanced Nutrients',
      nutrient: 'Balanced Nutrients',
      imageUrl:
          'https://5.imimg.com/data5/SELLER/Default/2021/6/WZ/AA/GK/11149701/plant-booster-organic-manure-fertilizer-500x500.png',
      ingredients: [
        '1 kg well-decomposed cow dung',
        '10 liters water',
      ],
      preparation: [
        'Mix thoroughly.',
        'Let it sit for 24 hours.',
        'Strain the liquid.',
      ],
      application: 'Water plants every 2 weeks.',
      benefits: [
        'Provides balanced nutrients.',
        'Improves soil microorganisms.',
      ],
    ),
  ];

  static const _itemsBn = <Fertilizer>[
    Fertilizer(
      id: '1',
      name: 'কলার খোসার সার',
      purpose: 'ফুল ও ফল উৎপাদন বৃদ্ধি',
      nutrient: 'পটাসিয়াম',
      imageUrl:
          'https://www.littlepassports.com/wp-content/uploads/2021/04/7a3de644-banana-peel-fertilizer.jpg',
      ingredients: ['২–৩টি কলার খোসা', '১ লিটার পানি'],
      preparation: [
        'খোসাগুলো ছোট ছোট টুকরো করে কাটুন।',
        'পানিতে ২৪–৪৮ ঘণ্টা ভিজিয়ে রাখুন।',
        'তরল ছেঁকে নিন।',
      ],
      application: 'প্রতি সপ্তাহে একবার গাছে পানি দিন।',
      benefits: [
        'পটাসিয়ামে ভরপুর।',
        'ফুল ও ফল উৎপাদন ত্বরান্বিত করে।',
      ],
    ),
    Fertilizer(
      id: '2',
      name: 'ডিমের খোসার সার',
      purpose: 'ক্যালসিয়াম বৃদ্ধি',
      nutrient: 'ক্যালসিয়াম',
      imageUrl:
          'https://tse1.mm.bing.net/th/id/OIP.N5gX1ngWgwBGNYgc2Q2zpQHaEK?r=0&w=1024&h=576&rs=1&pid=ImgDetMain&o=7&rm=3',
      ingredients: ['৫–৬টি ডিমের খোসা'],
      preparation: [
        'খোসাগুলো ভালো করে ধুয়ে নিন।',
        'রোদে সম্পূর্ণ শুকিয়ে নিন।',
        'মিহি গুঁড়ো করে নিন।',
      ],
      application: 'প্রতি মাসে গাছের গোড়ায় গুঁড়ো ছিটিয়ে দিন।',
      benefits: [
        'প্রয়োজনীয় ক্যালসিয়াম সরবরাহ করে।',
        'ক্যালসিয়ামের অভাব রোধ করে।',
      ],
    ),
    Fertilizer(
      id: '3',
      name: 'চাল ধোয়া পানির সার',
      purpose: 'শিকড়ের বৃদ্ধি',
      nutrient: 'ভিটামিন ও খনিজ',
      imageUrl:
          'https://tse3.mm.bing.net/th/id/OIP.Tif-sUvxKoHxgIwsHcFImwHaGz?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
      ingredients: ['চাল ধোয়ার প্রথম বা দ্বিতীয় বারের পানি'],
      preparation: ['চাল ধোয়া পানি সংগ্রহ করুন।'],
      application: 'অবিলম্বে গাছের গোড়ায় পানি হিসেবে দিন।',
      benefits: [
        'ভিটামিন, খনিজ ও স্টার্চ সমৃদ্ধ।',
        'শিকড়ের সুস্থ বৃদ্ধি নিশ্চিত করে।',
      ],
    ),
    Fertilizer(
      id: '4',
      name: 'চা পাতার কম্পোস্ট',
      purpose: 'মাটির উর্বরতা বৃদ্ধি',
      nutrient: 'জৈব পদার্থ',
      imageUrl:
          'https://earthcrew.com/wp-content/uploads/2023/11/Tea-Leaf-Compost.jpg',
      ingredients: ['ব্যবহৃত চা পাতা (চিনি ও দুধ ছাড়া)'],
      preparation: [
        'প্রয়োজনে ধুয়ে নিন।',
        'ব্যবহারের আগে শুকিয়ে নিন।',
      ],
      application: 'মাটির সাথে মিশিয়ে দিন।',
      benefits: [
        'জৈব পদার্থ যোগ করে।',
        'মাটির গুণমান উন্নত করে।',
      ],
    ),
    Fertilizer(
      id: '5',
      name: 'সবজির খোসার কম্পোস্ট',
      purpose: 'সুষম মাটির উর্বরতা',
      nutrient: 'সুষম পুষ্টি',
      imageUrl:
          'https://plantly.io/wp-content/uploads/2023/02/Untitled-design-4-1-1536x1024.jpg',
      ingredients: ['সবজির খোসা', 'শুকনো পাতা', 'মাটি'],
      preparation: [
        'সবজির খোসা ও শুকনো পাতার স্তর সাজান।',
        'মাটি দিয়ে ঢেকে দিন।',
        '৩০–৪৫ দিন পচতে দিন।',
      ],
      application: 'বাগানের মাটির সাথে মিশিয়ে ব্যবহার করুন।',
      benefits: [
        'সুষম পুষ্টি সরবরাহ করে।',
        'মাটির উর্বরতা বাড়ায়।',
      ],
    ),
    Fertilizer(
      id: '6',
      name: 'সরিষার খৈল সার',
      purpose: 'গাছের সতেজ বৃদ্ধি',
      nutrient: 'নাইট্রোজেন',
      imageUrl:
          'https://organicbazar.net/cdn/shop/products/Mustard-Cake.jpg?v=1694167824&width=1946',
      ingredients: ['১০০ গ্রাম সরিষার খৈল', '২ লিটার পানি'],
      preparation: [
        '২–৩ দিন পানিতে ভিজিয়ে রাখুন।',
        'ব্যবহারের আগে সমপরিমাণ পানি মিশিয়ে পাতলা করুন।',
      ],
      application: '১৫–২০ দিন পর পর প্রয়োগ করুন।',
      benefits: [
        'নাইট্রোজেনে সমৃদ্ধ।',
        'পাতার সতেজতা ও দ্রুত বৃদ্ধি ঘটায়।',
      ],
    ),
    Fertilizer(
      id: '7',
      name: 'কাঠের ছাই সার',
      purpose: 'ফুল ফোটাতে সহায়তা',
      nutrient: 'পটাসিয়াম ও ক্যালসিয়াম',
      imageUrl:
          'https://www.myearthgarden.com/wp-content/uploads/2025/10/wood-ash-fertilizer.jpeg',
      ingredients: ['পরিষ্কার কাঠের ছাই (কয়লা বা রাসায়নিকমুক্ত)'],
      preparation: ['ঠাণ্ডা ছাই সংগ্রহ করুন।'],
      application: 'গাছের চারপাশে সামান্য পরিমাণে ছিটিয়ে দিন।',
      benefits: [
        'পটাসিয়াম ও ক্যালসিয়াম সমৃদ্ধ।',
        'ফুল ফোটাতে সাহায্য করে।',
      ],
    ),
    Fertilizer(
      id: '8',
      name: 'পেঁয়াজের খোসার সার',
      purpose: 'অণুপুষ্টি বৃদ্ধি',
      nutrient: 'মাইক্রোনিউট্রিয়েন্ট',
      imageUrl:
          'https://i.ytimg.com/vi/EIqcmOFKLC8/maxresdefault.jpg',
      ingredients: ['পেঁয়াজের খোসা', '১ লিটার পানি'],
      preparation: [
        'খোসাগুলো ২৪ ঘণ্টা ভিজিয়ে রাখুন।',
        'পানি ছেঁকে নিন।',
      ],
      application: 'প্রতি দুই সপ্তাহে একবার গাছে পানি দিন।',
      benefits: [
        'প্রয়োজনীয় অণুপুষ্টি সরবরাহ করে।',
        'গাছের সার্বিক বৃদ্ধিতে সাহায্য করে।',
      ],
    ),
    Fertilizer(
      id: '9',
      name: 'মাছের উচ্ছিষ্ট সার',
      purpose: 'বলিষ্ঠ ও দ্রুত বৃদ্ধি',
      nutrient: 'নাইট্রোজেন ও ফসফরাস',
      imageUrl:
          'https://hakaimagazine.com/wp-content/uploads/header-fisheries-waste-to-wealth-1536x738.jpg',
      ingredients: [
        'মাছের আঁশ বা উচ্ছিষ্ট',
        'পানি',
        'বায়ুরোধী পাত্র',
      ],
      preparation: [
        'পাত্রে মাছের উচ্ছিষ্ট রাখুন।',
        'পানি যোগ করুন।',
        'প্রায় ২ সপ্তাহ গাঁজন হতে দিন।',
        'ব্যবহারের আগে ১:১০ অনুপাতে পানি মিশিয়ে পাতলা করুন।',
      ],
      application: 'প্রতি ২–৩ সপ্তাহে একবার প্রয়োগ করুন।',
      benefits: [
        'নাইট্রোজেন ও ফসফরাসে ভরপুর।',
        'গাছের দ্রুত বৃদ্ধি নিশ্চিত করে।',
      ],
    ),
    Fertilizer(
      id: '10',
      name: 'তরল গোবর সার',
      purpose: 'সুষম পুষ্টি',
      nutrient: 'সুষম পুষ্টি',
      imageUrl:
          'https://5.imimg.com/data5/SELLER/Default/2021/6/WZ/AA/GK/11149701/plant-booster-organic-manure-fertilizer-500x500.png',
      ingredients: ['১ কেজি পচা শুকনো গোবর', '১০ লিটার পানি'],
      preparation: [
        'ভালোভাবে মিশিয়ে নিন।',
        '২৪ ঘণ্টা রেখে দিন।',
        'তরল ছেঁকে নিন।',
      ],
      application: 'প্রতি ২ সপ্তাহে একবার গাছে দিন।',
      benefits: [
        'সুষম পুষ্টি সরবরাহ করে।',
        'মাটির উপকারী জীবাণু বৃদ্ধি করে।',
      ],
    ),
  ];
}

