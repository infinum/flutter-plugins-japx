import 'package:flutter_test/flutter_test.dart';

import 'test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('are invoked by the store', () async {
    Map<String, dynamic> sample1 = await decodingSample1();
    expect(sample1, sample1);
  });
}
