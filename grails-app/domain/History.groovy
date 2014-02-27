class History {

    static mapping = {
        table 'COMMON.HISTORY'
        version false
        id column:'HISTORY_ID'
    }

    GDOCUser user
    Study study
    Date dateCreated

    //static hasMany = [Studies: Study]
    //static fetchMode = [studies: "eager"]
    //Date lastUpdated
}