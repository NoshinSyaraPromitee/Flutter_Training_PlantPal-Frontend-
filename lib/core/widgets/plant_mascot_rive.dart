import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PlantMascotRive extends StatefulWidget {
  const PlantMascotRive({super.key, this.fit = Fit.contain});
  final Fit fit;

  @override
  State<PlantMascotRive> createState() => _PlantMascotRiveState();
}

class _PlantMascotRiveState extends State<PlantMascotRive> {
  late final FileLoader _fileLoader = FileLoader.fromAsset(
    'assets/animations/plant.riv',
    riveFactory: Factory.rive,
  );

  ViewModelInstanceBoolean? _mouthOpen;
  ViewModelInstanceNumber? _numState;
  ViewModelInstanceTrigger? _trigState;
  bool _mouthIsOpen = false;
  double _num = 0;

  // Called once from onLoaded, NOT from build().
  void _bind(RiveWidgetController controller) {
    final vmi = controller.dataBind(DataBind.auto());
    _mouthOpen = vmi.boolean('mouthOpen');
    _numState = vmi.number('numState');
    _trigState = vmi.trigger('trigState');
    debugPrint('[PlantMascotRive] mouthOpen=${_mouthOpen != null} '
        'numState=${_numState != null} trigState=${_trigState != null}');
  }

  void _onTap() {
    _mouthIsOpen = !_mouthIsOpen;
    _mouthOpen?.value = _mouthIsOpen;
    _num = (_num + 1) % 3;
    _numState?.value = _num;
    _trigState?.trigger();
  }

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: _fileLoader,
      stateMachineSelector: StateMachineSelector.byName('State Machine 1'),
      onLoaded: (state) => _bind(state.controller),
      builder: (context, state) => switch (state) {
        RiveLoading() => const Center(child: CircularProgressIndicator()),
        RiveFailed() => Center(
            child: Text('Rive load failed:\n${state.error}',
                style: const TextStyle(color: Colors.red, fontSize: 10),
                textAlign: TextAlign.center),
          ),
        RiveLoaded() => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            child: RiveWidget(controller: state.controller, fit: widget.fit),
          ),
      },
    );
  }
}