public enum SubjectType {
	PATIENT,
	SAMPLE, 
	CELL_LINE,
	ANIMAL_MODEL,
	REPLICATE;

	public String value() {
		return name();
	}

	public static SubjectType fromValue(String v) {
		return valueOf(v);
	}
	
}