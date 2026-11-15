import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests_gabriel/utils/cart_calculator.dart';
void main() {
  group('CartCalculator', () {
    late CartCalculator cart;

    setUp(() {
      cart = CartCalculator();
    });

    test('Add item: increases subtotal accurately', () {
      cart.addItem(10.00); // Default quantity is 1
      expect(cart.subtotal, 10.00);

      cart.addItem(5.50, quantity: 2); // Adds 11.00
      expect(cart.subtotal, 21.00);
    });

    test('Calculate total: computes tax and discount properly', () {
      cart.addItem(100.00);

      // Default taxRate is 0.08 (8%), default discount is 0.0
      expect(cart.calculateTotal(), 108.00);

      expect(cart.calculateTotal(taxRate: 0.10, discount: 20.00), 88.00);
    });

    test('Clear cart: resets subtotal to 0.0', () {
      cart.addItem(25.00, quantity: 3);
      expect(cart.subtotal, 75.00);

      cart.clearCart();
      expect(cart.subtotal, 0.0);
    });

    test('Exception handling: throws ArgumentError on negative price', () {
      expect(
        () => cart.addItem(-5.00),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
