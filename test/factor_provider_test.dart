import 'package:flutter_test/flutter_test.dart';
import 'package:calm_notes/providers/factor_provider.dart';

void main() {
  late FactorProvider factorProvider;

  setUp(() async {
    factorProvider = FactorProvider();
  });

  test('Initial state is correct', () {
    expect(factorProvider.selectedFactor, '');
  });

  test('addfactor adds a new factor', () async {
    factorProvider.selectFactor('work');

    expect(factorProvider.selectedFactor, 'work');
  });

  test('deletefactor removes the factor', () async {
    factorProvider.removeFactor();

    expect(factorProvider.selectedFactor, '');
  });
}
