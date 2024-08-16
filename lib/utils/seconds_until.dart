int secondsUntil(DateTime dateTime) {
  DateTime now = DateTime.now();
  int secondsDifference = dateTime.difference(now).inSeconds;
  if (secondsDifference < 0) {
    return 0;
  }
  return secondsDifference;
}
