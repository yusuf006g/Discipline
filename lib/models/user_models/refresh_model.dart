class RefreshModel {
  final String refresh;

  RefreshModel({
    required this.refresh,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
    };
  }
}