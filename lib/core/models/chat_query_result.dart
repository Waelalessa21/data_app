class ChatQueryResult {
  final String sql;
  final List<String> headers;
  final List<List<dynamic>> rows;
  final String? imageUrl;

  const ChatQueryResult({
    required this.sql,
    required this.headers,
    required this.rows,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'sql': sql,
    'headers': headers,
    'rows': rows.map((r) => r.map((e) => e.toString()).toList()).toList(),
    if (imageUrl != null) 'image_url': imageUrl,
  };

  Map<String, dynamic> toFirestoreMap() => {
    'sql': sql,
    'headers': headers,
    'rows': rows
        .map(
          (r) => {
            for (var i = 0; i < r.length; i++) i.toString(): r[i].toString(),
          },
        )
        .toList(),
    if (imageUrl != null) 'image_url': imageUrl,
  };

  factory ChatQueryResult.fromJson(Map<String, dynamic> json) {
    final headers =
        (json['headers'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final rowsRaw = json['rows'] as List<dynamic>? ?? [];
    final rows = rowsRaw.map((r) {
      if (r is Map) {
        final m = r;
        final indices = m.keys.map((e) => int.parse(e.toString())).toList()
          ..sort();
        return indices.map((i) => m[i.toString()] as dynamic).toList();
      }
      return (r as List<dynamic>).map((e) => e as dynamic).toList();
    }).toList();
    return ChatQueryResult(
      sql: json['sql'] as String? ?? '',
      headers: headers,
      rows: rows,
      imageUrl: json['image_url'] as String?,
    );
  }

  factory ChatQueryResult.fromFirestoreMap(Map<String, dynamic> json) {
    return ChatQueryResult.fromJson(json);
  }
}
