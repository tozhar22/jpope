// Classe qui modelise un utilsateur depuis firestore
class UserInfo {
  final String userId;
  final String username;
  final String email;

  UserInfo({required this.userId, required this.username, required this.email});
}