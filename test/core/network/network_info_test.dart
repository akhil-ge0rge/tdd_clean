import 'package:clean_tdd_trivian/core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivityPlus extends Mock implements Connectivity {}

void main() {
  late NetworkInfo networkInfo;
  late Connectivity connectivity;

  setUp(() {
    connectivity = MockConnectivityPlus();
    networkInfo = NetworkInfoImpl(connectivity);
  });

  group('isConnected', () {
    test('should retrun true when connected to wifi', () async {
      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((invocation) async => [ConnectivityResult.wifi]);

      final res = await networkInfo.isConnected;

      expect(res, true);
      verify(() => connectivity.checkConnectivity()).called(1);
      verifyNoMoreInteractions(connectivity);
    });
    test('should retrun true when connected to mobile', () async {
      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((invocation) async => [ConnectivityResult.mobile]);

      final res = await networkInfo.isConnected;

      expect(res, true);
      verify(() => connectivity.checkConnectivity()).called(1);
      verifyNoMoreInteractions(connectivity);
    });
    test('should retrun true when connected to ethernet', () async {
      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((invocation) async => [ConnectivityResult.ethernet]);

      final res = await networkInfo.isConnected;

      expect(res, true);
      verify(() => connectivity.checkConnectivity()).called(1);
      verifyNoMoreInteractions(connectivity);
    });
    test('should retrun false when not internet', () async {
      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((invocation) async => [ConnectivityResult.none]);

      final res = await networkInfo.isConnected;

      expect(res, false);
      verify(() => connectivity.checkConnectivity()).called(1);
      verifyNoMoreInteractions(connectivity);
    });
  });
}
