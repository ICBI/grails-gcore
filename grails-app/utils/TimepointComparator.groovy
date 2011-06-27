class TimepointComparator implements Comparator {
	public int compare(Object obj1, Object obj2) {
		def tp1 = obj1 =~ /[^0-9]*([0-9]*)[^0-9]*/
		def tp2 = obj2 =~ /[^0-9]*([0-9]*)[^0-9]*/
		
		return tp1[0][1].toInteger().compareTo(tp2[0][1].toInteger())
	}
}