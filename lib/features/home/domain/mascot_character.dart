/// Selectable main-menu mascots.
enum MascotCharacter {
  plant('Tetoro', 'assets/animations/plant.riv'),
  bloop('Bloop', 'assets/animations/bloop.riv'),
  tomato('Tomi', 'assets/animations/tomato.riv');

  const MascotCharacter(this.displayName, this.asset);
  final String displayName;
  final String asset;

  MascotCharacter get next =>
      MascotCharacter.values[(index + 1) % MascotCharacter.values.length];

  MascotCharacter get previous => MascotCharacter.values[
      (index - 1 + MascotCharacter.values.length) % MascotCharacter.values.length];
}