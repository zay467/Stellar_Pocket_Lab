String truncateMiddle(String data, int count) {
  return data.substring(0, count) +
      " . . . " +
      data.substring(data.length - count);
}
