
class StudySelectionFilters {
	
	def studyDataSourceService

    def filters = {
        all(controller:'(kmGeneExp|km|dicom|variantSearch|heatMap|groupComparison|pca|cin|geneExpression|molecularTarget|clinical|phenotypeSearch)', action:'index') {
            before = {
				log.debug("inside filter")
				if(!session.study || (params.chooseStudy && params.chooseStudy == "true")) {
					redirect (controller:'workflows', action: 'chooseStudy', params:[operation: controllerName])
					return false
				}
				else {
					if(!studyDataSourceService.doesStudySupportOperation(controllerName, session.study)) {
						//flash.operationNotSupported = "*** This operation is not supported.***"
						redirect(controller: 'workflows', action: 'studySpecificTools')
						return false
					} 
				}
            }
            after = {
                
            }
            afterView = {
                
            }
        }
    }
    
}