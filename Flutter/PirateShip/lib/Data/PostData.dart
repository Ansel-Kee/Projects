// we use this class to store the data for a post's data

class PostData {
  String creator;
  bool mediaIsImage;
  bool mediaIsVideo;
  String mediaLink;
  bool hasTitle;
  String title;
  int viewsCount;
  int forwrdsCount;

  PostData({
    required this.creator,
    required this.mediaIsImage,
    required this.mediaIsVideo,
    required this.mediaLink,
    required this.hasTitle,
    required this.title,
    required this.viewsCount,
    required this.forwrdsCount,
  });
}
