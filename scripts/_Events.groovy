eventPackagePluginStart = { 
     // hack to get the sql files into the zip 
     String dir = "$projectWorkDir/plugin-info/sql" 
     ant.mkdir dir: dir 
     ant.copy file: "$basedir/sql/01_study_setup_template.sql", todir: dir 
     ant.copy file: "$basedir/sql/02_study_schema_template.sql", todir: dir 
     ant.copy file: "$basedir/sql/03_study_grants_template.sql", todir: dir 
     ant.copy file: "$basedir/sql/study_cleanup_template.sql", todir: dir 
     ant.copy file: "$basedir/sql/delete_study.sql", todir: dir 
}