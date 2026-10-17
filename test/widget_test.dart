import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:miquido/core/storage/storage_service.dart';
import 'package:miquido/main.dart';

class MockStorageService extends GetxService implements IStorageService {
  final Map<String, dynamic> _data = {};

  @override
  Future<void> init() async {}

  @override
  T? read<T>(String key) => _data[key] as T?;

  @override
  Future<void> write(String key, dynamic value) async {
    _data[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> clear() async {
    _data.clear();
  }
}

void main() {
  setUp(() {
    Get.reset();
    Get.put<IStorageService>(MockStorageService());
  });

  testWidgets('MiquidoApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MiquidoApp());
    await tester.pumpAndSettle();

    // Verify Home text is present
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Upcoming'), findsOneWidget);
  });
}
