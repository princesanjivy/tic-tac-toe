class Player {
  final String name;
  final String playerId;
  String chose = "";

  Player(
    this.name,
    this.playerId,
  );

  Map<String, dynamic> toJson() => {
        "name": name,
        "chose": chose,
      };
}
