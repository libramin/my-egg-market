class TimeCalculation {

 static String getTimeDiff(DateTime createDate){
    DateTime now = DateTime.now();
    Duration timeDiff = now.difference(createDate);
    if(timeDiff.inHours <= 1){
      return '${timeDiff.inMinutes}분 전';
    }else if (timeDiff.inHours <= 24){
      return '${timeDiff.inHours}시간 전';
    }else{
      return '${timeDiff.inDays}일 전';
    }
  }

}