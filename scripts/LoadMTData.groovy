import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import org.springframework.orm.hibernate3.SessionFactoryUtils
import org.springframework.orm.hibernate3.SessionHolder
import org.springframework.transaction.support.TransactionSynchronizationManager


grailsHome = Ant.antProject.properties."env.GRAILS_HOME"
includeTargets << grailsScript("Bootstrap")
includeTargets << grailsScript("Init")

target(main: "Load data into the DB from molecule/target files") {
	depends(clean, compile, classpath)
	
	// Load up grails contexts to be able to use GORM
	loadApp()
	configureApp()
	
	//load target file into memory
	//parse small molecule (drug file)
	//persist molecule, look up target from this target hash
	//if target found in hash, persist a new target molecule
	def drugs = new XmlSlurper().parse(new File("/Users/kmr75/Documents/gu/gdocRelated/DDG-Schema/drugbank/drugbank.xml"))
	def drugCount = 0
	drugs.drug.name.each{
	  drugCount += 1
	}
	println "apparently $drugCount drugs"
	
	def geneAliasClass = classLoader.loadClass('GeneAlias')
	def geneClass = classLoader.loadClass('Gene')
	def proteinClass = classLoader.loadClass('Protein')
	def targetFile = new File("/Users/kmr75/Documents/gu/gdocRelated/DDG-Schema/drugbank/Dave_curated_target_list.txt")
	def targetMap = [:]
	println "looking up genes..."
	targetFile.eachLine{line, number ->
		if(number != 1) {
			def data = line.split('\t')
			if(data.length >=2){
				def gene = geneClass.get(data[1])
				if(gene){
					//println "found " + official.symbol + " with id of " + data[0]
					targetMap[data[0]] = gene
				}
				//println "found geneSymbols  " +  geneSymbols
				/**def official = geneSymbols.find{
					if(it.official){
						return it
					}	
				}
				if(official){
					//println "get gene for $official"
					def gene = geneClass.withCriteria(uniqueResult:true) { 
					      geneAliases { 
					            eq('id', official.id) 
					       } 
					}
					println "found geneClass  " +  gene
					if(gene){
						println "found " + official.symbol + " with id of " + data[0]
						targetMap[data[0]] = gene
					}
				}**/
				
			}
		}
	}
	println targetMap.keySet().size() + " genes found out of 2172"
	//load()
	//manipulateSDF("test")
}

/**def captureTargets(){
	
	def moleculeClass = classLoader.loadClass('Molecule')
	def proteinClass = classLoader.loadClass('Protein')
	def moleculatTargetClass = classLoader.loadClass('MoleculeTarget')
	def mols = moleculatTargetClass.findAll()
	println mols
	def targetFile = new File("/Users/kmr75/Desktop/targets.txt")
	targetFile.eachLine{line, number ->
		if(number != 1) {
			def data = line.split('\t')
			//println data[0]
		}
	}
}**

/**def load(){
	def sessionFactory = appCtx.getBean("sessionFactory")
	def session = sessionFactory.getCurrentSession()
	def trans = session.beginTransaction()
	def moleculeService = appCtx.getBean("moleculeService")
	try {
		println "load data: $trans"
		moleculeService.createMolecules("/Users/kmr75/Documents/gu/gdocRelated/DDG-Schema/DDGData_Clean.xls")
		trans.commit()
	} catch (Exception e) {
		trans.rollback()
		e.printStackTrace()
	}
	
	
}**/

def manipulateSDF(projectName) {
	println "read from sdf file:"
	def sdfFile= new File('/Users/kmr75/Documents/gu/gdocRelated/DDG-Schema/Sample-Compounds-Clean.sdf')
	def nameSdfFile= new FileWriter('/Users/kmr75/Documents/gu/gdocRelated/DDG-Schema/Sample-Compounds-WithNames.sdf')
	
	def newCompound = false
	def numberOfCopmounds = 0
	def compoundName = ""
	sdfFile.eachLine { line ->
		if(newCompound){
			compoundName = line
			//println "found file name: $line"
			numberOfCopmounds++
			newCompound = false
		}
		if(line == '$$$$'){
			newCompound = true
		}
		if(line == 'M  END' && compoundName){
			line+= "\n>  <NAME>\n $compoundName \n"
		}
		nameSdfFile.append(line + "\n")
	}
	println "read $numberOfCopmounds compounds"
}

setDefaultTarget(main)
