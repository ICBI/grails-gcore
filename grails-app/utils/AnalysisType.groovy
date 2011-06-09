public enum AnalysisType {
	KM_PLOT,
	CLASS_COMPARISON, 
	GENE_EXPRESSION,
	KM_GENE_EXPRESSION,
	KM_COPY_NUMBER,
	HEATMAP,
	PCA,
	CIN;

	public String value() {
		if(name()=="CLASS_COMPARISON"){
			return "GROUP_COMPARISON"
		}
		else{
			return name()
		}
	}

	public static AnalysisType fromValue(String v) {
		return valueOf(v);
	}
	
}