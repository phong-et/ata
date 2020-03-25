bool isCheckinLate(DateTime startWorkTime, DateTime checkingTime, int acceptableLateTime) {
    int seconds = checkingTime.difference(startWorkTime).inSeconds;
    print('seconds:$seconds');
    print('acceptableLateTime: $acceptableLateTime');
    return seconds > acceptableLateTime;
    //return checkingTime.difference(startWorkTime).inSeconds > acceptableLateTime;
}
bool isCheckinEarly(DateTime startWorkTime, DateTime checkingTime, int acceptableLateTime) {
    int seconds = checkingTime.difference(startWorkTime).inSeconds;
    print('seconds:$seconds');
    print('acceptableLateTime: $acceptableLateTime');
    return seconds < 0;
    //return checkingTime.difference(startWorkTime).inSeconds > acceptableLateTime;
}
main(){
  bool isLate = isCheckinLate(DateTime.now().add(Duration(seconds: 900)), DateTime.now().add(Duration(seconds: 900)), 900);
  print(isLate);
  bool isEarly = isCheckinEarly(DateTime.now().add(Duration(seconds: 901)), DateTime.now().add(Duration(seconds: 900)), 900);
  print(isEarly);
}