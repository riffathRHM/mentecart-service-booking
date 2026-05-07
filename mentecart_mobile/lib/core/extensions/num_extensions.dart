extension NumExtension on num {
  /// Format as currency
  String toCurrency([String symbol = '\$', int decimals = 2]) {
    return '$symbol${toStringAsFixed(decimals)}';
  }

  /// Format as percentage
  String toPercentage([int decimals = 1]) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Convert to string with thousand separator
  String toFormattedString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Check if number is between range
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }

  /// Get absolute value
  num abs() => this < 0 ? -this : this;
}