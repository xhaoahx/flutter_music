// single lyric
class Lyric {
  Lyric(this.end, this.content);

  static Iterable<Lyric> fromLines(String lines) sync* {
    final reg = RegExp(_reg, multiLine: true);
    for (final match in reg.allMatches(lines)) {
      final minute = int.parse(match.group(1)!);
      final second = int.parse(match.group(2)!);
      final millisecond = int.parse(match.group(3)!);
      final content = match.group(4);
      yield Lyric(
        Duration(
            milliseconds: minute * 60 * 1000 + second * 1000 + millisecond),
        content ?? '',
      );
    }
  }

  factory Lyric.fromLine(String line) {
    final reg = RegExp(_reg);
    final match = reg.allMatches(line).single;
    final minute = int.parse(match.group(1)!);
    final second = int.parse(match.group(2)!);
    final millisecond = int.parse(match.group(3)!);
    final content = match.group(4);
    return Lyric(
      Duration(milliseconds: minute * 60 * 1000 + second * 1000 + millisecond),
      content ?? '',
    );
  }

  static const _reg = r'\[([0-9]+):([0-9]+).([0-9]+)\](.*)';

  final Duration end;
  final String content;

  @override
  String toString() => '[$end] $content';
}

class LyricEntry {
  LyricEntry({
    this.ar,
    this.ti,
    this.al,
    this.by,
    this.offset = 0,
    required this.lyricList,
  });

  factory LyricEntry.empty() => LyricEntry(lyricList: const []);

  factory LyricEntry.form(String lrc) {
    final headEnd = lrc.indexOf(RegExp(r'\d'));
    assert(headEnd > 0);

    final map = Map.fromIterable(
      RegExp(_reg, multiLine: true).allMatches(lrc.substring(0, headEnd)),
      key: (match) => (match as Match).group(1),
      value: (match) => (match as Match).group(2),
    );

    return LyricEntry(
      ar: map['ar'],
      ti: map['ti'],
      al: map['al'],
      by: map['by'],
      offset: int.tryParse(map['offset'] ?? '0') ?? 0,
      lyricList: Lyric.fromLines(lrc.substring(headEnd - 1)).toList(),
    );
  }

  final String? ar;
  final String? ti;
  final String? al;
  final String? by;
  final int offset;
  final List<Lyric> lyricList;

  static const _reg = r'\[(.*):(.*)\]$';

  @override
  String toString() {
    return '<$ti>@$ar {${lyricList.elementAt(0)}...';
  }
}
