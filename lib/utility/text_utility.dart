
bool equalsIgnoreCase(String string1, String string2) {
	return string1?.toLowerCase() == string2?.toLowerCase();
}

String format(double n) {
	return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
}
