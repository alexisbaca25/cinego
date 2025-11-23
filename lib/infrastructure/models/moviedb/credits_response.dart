class CreditsResponse {
    final int id;
    final List<Cast> cast;
    final List<Cast> crew;

    CreditsResponse({
        required this.id,
        required this.cast,
        required this.crew,
    });

    factory CreditsResponse.fromJson(Map<String, dynamic> json) => CreditsResponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
    );
}

class Cast {
    final int id;
    final String name;
    final String originalName;
    final String? profilePath;
    final String? character;

    Cast({
        required this.id,
        required this.name,
        required this.originalName,
        required this.profilePath,
        required this.character,
    });

    factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        id: json["id"],
        name: json["name"],
        originalName: json["original_name"],
        profilePath: json["profile_path"],
        character: json["character"],
    );
}