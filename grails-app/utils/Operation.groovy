
public enum Operation {
	
	GENOME_BROWSER("Genome Browser", "Search", "genomeBrowser", "index","Visualize and browse genomic features using chromosomal position or gene identifier"),
	CLINICAL("Explore Clinical Data and Create Groups", "Search", "clinical", "index", "Explore clinical data and create groups"),
	TARGET("Compound/Drug Targets", "Search", "moleculeTarget", "index", "View complex drug-target structures in 3D"),
	GENE_EXPRESSION("Gene Expression Data", "Search", "geneExpression", "index", "Compare expression of a gene between two groups of samples"),
	DICOM("Medical Images", "Search", "dicom", "index", "Explore medical images"),
	PHENOTYPE_SEARCH("Phenotype Search", "Search", "phenotypeSearch", "index", "Explore genetic variation across different populations and understand how SNP frequencies impact drug metabolism."),
	VARIANT_SEARCH("Variant Search", "Search", "variantSearch", "index", "Explore variant data in whole genome/exome data"),
	CIN("Chromosomal Instability Index", "Analyze", "cin", "index", "Calculate chromosomal instability (CIN) index for cytobands, and whole chromosomes"),
	PCA("Classification", "Analyze", "pca", "index", "Classify high throughput data using principal component analysis (PCA)"),
	GROUP_COMPARISON("Group Comparison", "Analyze", "groupComparison", "index", "Perform differential expression analysis with high throughput data between two groups of samples using T- test or Mann-Whitney test"),
	HEAT_MAP("HeatMap Viewer", "Analyze", "heatMap", "index", "Perform heirarchical clustering using high throughput data and visualize as a heat map"),
	KM("KM Clinical Plot", "Analyze", "km", "index", "Perform Kaplam Meier survival analysis using clinical data"),
	KM_GENE_EXP("KM Gene Expression Plots", "Analyze", "kmGeneExp", "index", "Perform Kaplam Meier survival analysis using gene expression data")
	
	public Operation(String name, String type, String controller, String action, String description) {
		this.name = name;
		this.type = type;
		this.controller = controller;
		this.action = action;
        this.description = description;
	}
	
	String name = "";
	String controller = "";
	String action = "";
	String type = "";
    String description = "";
}
