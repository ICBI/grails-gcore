public enum AnnotationType {
	CELL_LINE;

	public String value() {
		return name();
	}

	public static AnnotationType fromValue(String v) {
		return valueOf(v);
	}
	
}