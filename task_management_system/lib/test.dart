import 'package:path/path.dart' as p;

void main() {
  print('Current path style: ${p.style}');

  print('Current process path: ${p.current}');

  print('Separators');
  for (var entry in [p.posix, p.windows, p.url]) {
    print('  ${entry.style.toString().padRight(7)}: ${entry.separator}');
  }
  print("object");
}