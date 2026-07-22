import 'package:flutter_test/flutter_test.dart';
import 'package:sosmed_downloader/main.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SosmedDownloaderApp());
    expect(find.text('Masuk'), findsWidgets);
  });
}
