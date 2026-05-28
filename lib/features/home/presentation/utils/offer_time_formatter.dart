String formatOfferCountdown(Duration duration) {
  final safeDuration = duration.isNegative ? Duration.zero : duration;
  final minutes = safeDuration.inMinutes
      .remainder(60)
      .toString()
      .padLeft(2, '0');
  final seconds = safeDuration.inSeconds
      .remainder(60)
      .toString()
      .padLeft(2, '0');

  return '$minutes:$seconds';
}

Duration remainingUntil(DateTime dateTime) {
  final remaining = dateTime.difference(DateTime.now());
  return remaining.isNegative ? Duration.zero : remaining;
}
