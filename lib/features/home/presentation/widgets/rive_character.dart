import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plantpal/core/widgets/plant_mascot_rive.dart';
import 'package:plantpal/features/home/domain/mascot_character.dart';
import 'package:rive/rive.dart';

/// Renders the chosen mascot. Plant keeps its own widget; Bloop and Tomi use
/// the generic loader below.
class RiveCharacter extends StatelessWidget {
  const RiveCharacter({super.key, required this.character});
  final MascotCharacter character;

  @override
  Widget build(BuildContext context) => switch (character) {
        MascotCharacter.plant => const PlantMascotRive(),
        MascotCharacter.bloop =>
          _RiveAsset(asset: character.asset, bind: _bindBloop),
        MascotCharacter.tomato => _RiveAsset(asset: character.asset),
      };
}

// Number of eye/expression variants in bloop.riv (changeEye-1..7).
// Lower this if the selector runs past the last expression.
const int _bloopExpressions = 7;

/// Bloop state machine inputs: isBlinkTwice, facialExpressionToggle,
/// facialExpressionSelector, Fire. Tap cycles through them.
VoidCallback? _bindBloop(RiveWidgetController c) {
  final sm = c.stateMachine;
  final toggle = sm.boolean('facialExpressionToggle');
  final selector = sm.number('facialExpressionSelector');
  final blinkBool = sm.boolean('isBlinkTwice');
  final blinkTrig = blinkBool == null ? sm.trigger('isBlinkTwice') : null;
  final fireTrig = sm.trigger('Fire');
  final fireBool = fireTrig == null ? sm.boolean('Fire') : null;

  debugPrint('[Bloop] toggle=${toggle != null} selector=${selector != null} '
      'blink=${blinkBool != null || blinkTrig != null} '
      'fire=${fireTrig != null || fireBool != null}');

  var on = false;
  var sel = 0;
  return () {
    on = !on;
    toggle?.value = on;

    sel = sel % _bloopExpressions + 1;
    selector?.value = sel.toDouble();

    if (blinkBool != null) {
      blinkBool.value = true;
      Future.delayed(const Duration(milliseconds: 400), () {
        blinkBool.value = false;
      });
    }
    blinkTrig?.fire();

    // Fire on every 3rd tap so it stays a surprise.
    if (sel % 3 == 0) {
      fireTrig?.fire();
      if (fireBool != null) {
        fireBool.value = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          fireBool.value = false;
        });
      }
    }
  };
}

class _RiveAsset extends StatefulWidget {
  const _RiveAsset({required this.asset, this.bind});
  final String asset;
  final VoidCallback? Function(RiveWidgetController c)? bind;

  @override
  State<_RiveAsset> createState() => _RiveAssetState();
}

class _RiveAssetState extends State<_RiveAsset> {
  late final FileLoader _loader = FileLoader.fromAsset(
    widget.asset,
    riveFactory: Factory.rive,
  );
  VoidCallback? _tap;

  @override
  void dispose() {
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: _loader,
      stateMachineSelector: StateMachineSelector.byName('State Machine 1'),
      onLoaded: (state) {
        try {
          _tap = widget.bind?.call(state.controller);
        } catch (e) {
          debugPrint('[RiveCharacter] bind failed: $e');
        }
      },
      builder: (context, state) => switch (state) {
        RiveLoading() => const Center(child: CircularProgressIndicator()),
        RiveFailed() => Center(
            child: Text('Rive load failed:\n${state.error}',
                style: const TextStyle(color: Colors.red, fontSize: 10),
                textAlign: TextAlign.center),
          ),
        RiveLoaded() => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _tap?.call(),
            child: RiveWidget(controller: state.controller, fit: Fit.contain),
          ),
      },
    );
  }
}