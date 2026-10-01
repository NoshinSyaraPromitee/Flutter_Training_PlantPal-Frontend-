import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plantpal/features/home/domain/mascot_character.dart';

class MascotController extends Notifier<MascotCharacter> {
  static const _key = 'menu_mascot';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  MascotCharacter build() {
    unawaited(_load());
    return MascotCharacter.plant;
  }

  Future<void> _load() async {
    try {
      final saved = await _storage.read(key: _key);
      for (final c in MascotCharacter.values) {
        if (c.name == saved) {
          state = c;
          return;
        }
      }
    } catch (_) {}
  }

  Future<void> select(MascotCharacter c) async {
    state = c;
    try {
      await _storage.write(key: _key, value: c.name);
    } catch (_) {}
  }

  void next() => select(state.next);
  void previous() => select(state.previous);
}

final mascotControllerProvider =
    NotifierProvider<MascotController, MascotCharacter>(MascotController.new);