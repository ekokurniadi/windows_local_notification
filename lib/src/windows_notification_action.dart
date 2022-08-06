class WindowsNotificationAction {
  /// The type of action, can be button.
  String type;

  /// The label for the given action.
  String? text;

  WindowsNotificationAction({
    this.type = 'button',
    this.text,
  });

  factory WindowsNotificationAction.fromJson(Map<String, dynamic> json) {
    return WindowsNotificationAction(
      type: json['type'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
    }..removeWhere((key, value) => value == null);
  }
}
