// the class we use to store a user profile that we can display
// in a profile page

// ignore_for_file: camel_case_types
class UserProfile {
  String UID;
  String username;
  String fullname;
  String bio;
  String compressedProfileImageLink;
  String profileImageLink;
  int forwrdsCount;
  int friendsCount;
  int postsCount;

  UserProfile({
    required this.UID,
    required this.username,
    required this.fullname,
    required this.bio,
    required this.compressedProfileImageLink,
    required this.forwrdsCount,
    required this.friendsCount,
    required this.postsCount,
    required this.profileImageLink,
  });
}
