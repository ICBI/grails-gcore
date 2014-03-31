
public enum Operation {
	
	GENOME_BROWSER("Genome Browser", "Search", "genomeBrowser", "index"),
	CLINICAL("Explore Clinical Data and Create Groups", "Search", "clinical", "index"),
	TARGET("Compound/Drug Targets", "Search", "moleculeTarget", "index"),
	GENE_EXPRESSION("Plot Gene Expression", "Search", "geneExpression", "index"),
	DICOM("Medical Images", "Search", "dicom", "index"),
	PHENOTYPE_SEARCH("Phenotype Search", "Search", "phenotypeSearch", "index"),
	VARIANT_SEARCH("Variant Search", "Search", "variantSearch", "index"),
	CIN("Chromosomal Instability Index", "Analyze", "cin", "index"),
	PCA("Classification", "Analyze", "pca", "index"),
	GROUP_COMPARISON("Group Comparison", "Analyze", "groupComparison", "index"),
	HEAT_MAP("HeatMap Viewer", "Analyze", "heatMap", "index"),
	KM("KM Clinical Plot", "Analyze", "km", "index"),
	KM_GENE_EXP("KM Gene Expression Plots", "Analyze", "kmGeneExp", "index")
	
	public Operation(String name, String type, String controller, String action) {
		this.name = name;
		this.type = type;
		this.controller = controller;
		this.action = action;
	}
	
	String name = "";
	String controller = "";
	String action = "";
	String type = "";	
}
