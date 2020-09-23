class BasePageResponse<T> {
  final int count;
  final int pages;
  final String next;
  final String prev;
  final T data;

  bool get hasNextPage => next != null;

  BasePageResponse(this.count, this.pages, this.next, this.prev, this.data);

  factory BasePageResponse.fromJson(Map<String, dynamic> info, T data) {
    return BasePageResponse(info["count"], info["pages"], info["next"], info["prev"], data);
  }

}
