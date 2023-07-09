class Player {
  final String name;
  final String playerId;
  final String displayPicture;
  String chose = "";
  int winCount = 0;

  Player(
    this.name,
    this.playerId,
    this.displayPicture,
  );

  Player.fromRoomDataJson(json)
      : chose = json!["chose"],
        playerId = json!["id"],
        winCount = json!["winCount"],
        displayPicture = "",

        /// temp
        name = "";

  /// temp

  Player.fromJson(json)
      : name = json!["name"],
        displayPicture = json!["displayPicture"],
        playerId = json!["playerId"];

  Map<String, dynamic> toJson() => {
        "id": playerId,
        "chose": chose,
        "winCount": winCount,
      };

  Map<String, dynamic> toDbJson() => {
        "name": name,
        "playerId": playerId,
        "displayPicture": displayPicture,
      };
}
