import 'package:flutter_test/flutter_test.dart';
import 'package:uni_project/services/notification_service.dart';

void main() {
  group('NotificationService visibility rules', () {
    test('returns true for direct receiver matches', () {
      final notification = {
        'receiverId': 'user-123',
      };

      expect(NotificationService.shouldShowToUser(notification, 'user-123'), isTrue);
      expect(NotificationService.shouldShowToUser(notification, 'other-user'), isFalse);
    });

    test('returns true for broadcast and admin notifications', () {
      expect(
        NotificationService.shouldShowToUser({'receiverId': 'all'}, 'user-123'),
        isTrue,
      );
      expect(
        NotificationService.shouldShowToUser({'receiverId': 'ALL_USERS'}, 'user-123'),
        isTrue,
      );
      expect(
        NotificationService.shouldShowToUser({'isAdminNotification': true}, 'user-123'),
        isTrue,
      );
    });

    test('returns true when targetUsers contains the current user', () {
      final notification = {
        'targetUsers': ['user-1', 'user-123'],
      };

      expect(NotificationService.shouldShowToUser(notification, 'user-123'), isTrue);
      expect(NotificationService.shouldShowToUser(notification, 'user-999'), isFalse);
    });
  });
}
