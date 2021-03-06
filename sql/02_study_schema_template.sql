CREATE SEQUENCE ${projectName}.PATIENT_ATTRIB_VAL_SEQUENCE
  START WITH 2460
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE SEQUENCE ${projectName}.BIOSPECIMEN_SEQUENCE
  START WITH 1000
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE SEQUENCE ${projectName}.BIOSPECIMEN_VALUE_SEQUENCE
  START WITH 1000
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE SEQUENCE ${projectName}.HT_FILE_SEQUENCE
  START WITH 1000
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE SEQUENCE ${projectName}.reduction_analysis_SEQUENCE
  START WITH 100
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;


CREATE SEQUENCE ${projectName}.MS_PEAK_SEQUENCE
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE TABLE ${projectName}.MS_PEAK_EVIDENCE_LINK
(
  MS_PEAK_EVIDENCE_LINK_ID  NUMBER(10)          NOT NULL,
  MS_PEAK_ID                NUMBER(10)          NOT NULL,
  MS_PEAK_EVIDENCE_ID       NUMBER(10)          NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.MS_PEAK_GROUP_LINK
(
  MS_PEAK_GROUP_LINK_ID  NUMBER(10)             NOT NULL,
  MS_PEAK_GROUP_ID       NUMBER(10)             NOT NULL,
  MS_PEAK_ID             NUMBER(10)             NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.MS_PEAK
(
  MS_PEAK_ID     NUMBER(10)                     NOT NULL,
  NAME           VARCHAR2(20 BYTE)              NOT NULL,
  MZ             NUMBER                         NOT NULL,
  RETENTION      NUMBER,
  HT_FILE_ID     NUMBER(10),
  INSERT_USER    VARCHAR2(10 BYTE)              NOT NULL,
  INSERT_DATE    DATE                           NOT NULL,
  INSERT_METHOD  VARCHAR2(20 BYTE)              NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.HT_FILE
(
  HT_FILE_ID      NUMBER(10)                    NOT NULL,
  NAME            VARCHAR2(50 BYTE)             NOT NULL,
  DESIGN_ID		  NUMBER,
  DESCRIPTION     VARCHAR2(100 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE ${projectName}.HT_FILE_BIOSPECIMEN
( 
  HT_FILE_ID NUMBER NOT NULL, 
  BIOSPECIMEN_ID NUMBER NOT NULL, 
  CONSTRAINT HT_FILE_BIOSPECIMEN_PK PRIMARY KEY (HT_FILE_ID, BIOSPECIMEN_ID)
);



CREATE TABLE ${projectName}.KM_ATTRIBUTE
(
  KM_ATTRIBUTE_ID      NUMBER(10)               NOT NULL,
  CENSOR_ATTRIBUTE_ID  NUMBER(10)               NOT NULL,
  CENSOR_VALUE_ID      NUMBER(10)               NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE ${projectName}.BIOSPECIMEN
(
  BIOSPECIMEN_ID          NUMBER(10)            NOT NULL,
  NAME                    VARCHAR2(50 BYTE)     NOT NULL,
  SUBJECT_ID			  NUMBER(10)			NOT NULL,
  INSERT_DATE             DATE                  NOT NULL,
  primary key (BIOSPECIMEN_ID)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


create table  ${projectName}.reduction_analysis 
  (
  id number(19,0) not null, 
  version number(19,0), 
  algorithm varchar2(255), 
  algorithm_type varchar2(255),
  biospecimen_id number(19,0),
  date_created date not null, 
  name varchar2(255),
  design_type varchar2(255) not null
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

create table ${projectName}.SUBJECT (
	subject_id number(19,0) not null, 
	data_source_internal_id varchar2(255) not null, 
	type varchar2(255) not null, 
	timepoint varchar2(255), 
	parent_id number(19,0),
	insert_date date not null,
	primary key (subject_id));


CREATE TABLE ${projectName}.SUBJECT_ATTRIBUTE_VALUE(	
	SUBJECT_ATTRIBUTE_VALUE_ID NUMBER(10,0) NOT NULL, 
	SUBJECT_ID NUMBER(19,0) NOT NULL, 
	ATTRIBUTE_TYPE_ID NUMBER(10,0) NOT NULL, 
	VALUE VARCHAR2(2500 BYTE) NOT NULL,
	INSERT_DATE DATE NOT NULL, 
	 CONSTRAINT SAV_SUBJECT_FK FOREIGN KEY (SUBJECT_ID)
	  REFERENCES ${projectName}.SUBJECT (SUBJECT_ID) ENABLE
   );

CREATE INDEX  ${projectName}.SUBJECT_ATTRIBUTE_VALUE_INDEX1 ON  ${projectName}.SUBJECT_ATTRIBUTE_VALUE (ATTRIBUTE_TYPE_ID ASC) LOGGING NOPARALLEL;
	
CREATE UNIQUE INDEX  ${projectName}.reduction_analysis_PK ON ${projectName}.reduction_analysis
(ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.BIOSPECIMEN_NAME_AK ON ${projectName}.BIOSPECIMEN
(NAME)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MARRAY_FILE_PK ON ${projectName}.HT_FILE
(HT_FILE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.KM_ATTRIBUTE_PK ON ${projectName}.KM_ATTRIBUTE
(KM_ATTRIBUTE_ID, CENSOR_ATTRIBUTE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MARRAY_FILE_NAME_AK ON ${projectName}.HT_FILE
(NAME)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MS_PEAK_PK ON ${projectName}.MS_PEAK
(MS_PEAK_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MS_PEAK_NAME_AK ON ${projectName}.MS_PEAK
(NAME, HT_FILE_ID)
LOGGING
NOPARALLEL;


CREATE INDEX ${projectName}.MS_PEAK_FILE_IDX ON ${projectName}.MS_PEAK
(HT_FILE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MS_PEAK_GROUP_LINK_PK ON ${projectName}.MS_PEAK_GROUP_LINK
(MS_PEAK_GROUP_LINK_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MS_PEAK_GROUP_LINK_AK ON ${projectName}.MS_PEAK_GROUP_LINK
(MS_PEAK_ID, MS_PEAK_GROUP_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MS_PEAK_EVIDENCE_LINK_PK ON ${projectName}.MS_PEAK_EVIDENCE_LINK
(MS_PEAK_EVIDENCE_LINK_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MS_PEAK_EVIDENCE_LINK_AK ON ${projectName}.MS_PEAK_EVIDENCE_LINK
(MS_PEAK_ID, MS_PEAK_EVIDENCE_ID)
LOGGING
NOPARALLEL;

CREATE OR REPLACE VIEW ${projectName}.USED_ATTRIBUTES 
AS 
SELECT distinct c.attribute_type_id, c.short_name, c.long_name, c.definition, c.class, c.semantic_group, c.gdoc_preferred, c.cadsr_id, c.evs_id, c.qualitative, c.continuous, c.vocabulary, c.oracle_datatype, c.unit, c.upper_range, c.lower_range, s.type as target, c.split_attribute 
FROM common.attribute_type c inner join ${projectName}.subject_attribute_value v 
       on v.attribute_type_id = c.attribute_type_id inner join ${projectName}.subject s on v.subject_id = s.subject_id
WITH READ ONLY;


CREATE OR REPLACE VIEW ${projectName}.KM_ATTRIBUTES
AS 
select k.long_name KM_ATTRIBUTE, k.short_name KM_ATTRIBUTE_SHORT, c.long_name CENSOR_ATTRIBUTE, c.short_name CENSOR_ATTRIBUTE_SHORT , v.term CENSOR_VALUE
from ${projectName}.km_attribute km, attribute_type k, attribute_type c, attribute_vocabulary v
where km.km_attribute_id = k.attribute_type_id
and km.censor_attribute_id = c.attribute_type_id
and km.censor_value_id = v.attribute_vocabulary_id
WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW ${projectName}.HT_FILE_CONTENTS 
	(ID, FILE_NAME, BIOSPECIMEN_ID, BIOSPECIMEN_NAME, DESIGN_TYPE, DESIGN_ID) 
AS 
SELECT   ROWNUM id, f.name file_name, b.biospecimen_id biospecimen_id, b.name biospecimen_name, d.ARRAY_TYPE design_type, d.htarray_design_id design_id 
	FROM ${projectName}.ht_file f, 
		 ${projectName}.ht_file_biospecimen r, 
		 ${projectName}.biospecimen b, 
		 common.all_designs d 
	WHERE  r.ht_file_id = F.ht_FILE_ID 
		   AND r.biospecimen_id = b.biospecimen_id 
		   AND f.DESIGN_ID = d.htarray_design_id 
	WITH READ ONLY;

ALTER TABLE ${projectName}.HT_FILE ADD (
  CONSTRAINT HT_FILE_PK
 PRIMARY KEY
 (HT_FILE_ID));
	
ALTER TABLE ${projectName}.MS_PEAK_EVIDENCE_LINK ADD (
  CONSTRAINT MS_PEAK_EVIDENCE_LINK_PK
 PRIMARY KEY
 (MS_PEAK_EVIDENCE_LINK_ID));

ALTER TABLE ${projectName}.MS_PEAK_GROUP_LINK ADD (
  CONSTRAINT MS_PEAK_GROUP_LINK_PK
 PRIMARY KEY
 (MS_PEAK_GROUP_LINK_ID));

ALTER TABLE ${projectName}.MS_PEAK ADD (
  CONSTRAINT MS_PEAK_PK
 PRIMARY KEY
 (MS_PEAK_ID));

ALTER TABLE ${projectName}.KM_ATTRIBUTE ADD (
  CONSTRAINT KM_ATTRIBUTE_PK
 PRIMARY KEY
 (KM_ATTRIBUTE_ID, CENSOR_ATTRIBUTE_ID));

ALTER TABLE ${projectName}.reduction_analysis add (
 	CONSTRAINT reduction_analysis_pk
	PRIMARY KEY
	(ID)); 

ALTER TABLE ${projectName}.MS_PEAK_EVIDENCE_LINK ADD (
  CONSTRAINT MPEL_PEAK_FK 
 FOREIGN KEY (MS_PEAK_ID) 
 REFERENCES ${projectName}.MS_PEAK (MS_PEAK_ID),
  CONSTRAINT MPEL_EVIDENCE_FK 
 FOREIGN KEY (MS_PEAK_EVIDENCE_ID) 
 REFERENCES COMMON.MS_PEAK_EVIDENCE (MS_PEAK_EVIDENCE_ID));

ALTER TABLE ${projectName}.MS_PEAK_GROUP_LINK ADD (
  CONSTRAINT MPG_PEAK_GROUP_FK 
 FOREIGN KEY (MS_PEAK_GROUP_ID) 
 REFERENCES COMMON.MS_PEAK_GROUP (MS_PEAK_GROUP_ID),
  CONSTRAINT MPG_PEAK_FK 
 FOREIGN KEY (MS_PEAK_ID) 
 REFERENCES ${projectName}.MS_PEAK (MS_PEAK_ID));

ALTER TABLE ${projectName}.MS_PEAK ADD (
  CONSTRAINT MS_PEAK_FILE_FK 
 FOREIGN KEY (HT_FILE_ID) 
 REFERENCES ${projectName}.HT_FILE (HT_FILE_ID));

ALTER TABLE ${projectName}.KM_ATTRIBUTE ADD (
  CONSTRAINT KM_ATTR_CENSOR_ATTR_FK 
 FOREIGN KEY (CENSOR_ATTRIBUTE_ID) 
 REFERENCES COMMON.ATTRIBUTE_TYPE (ATTRIBUTE_TYPE_ID),
  CONSTRAINT KM_ATTR_KM_ATTR_FK 
 FOREIGN KEY (KM_ATTRIBUTE_ID) 
 REFERENCES COMMON.ATTRIBUTE_TYPE (ATTRIBUTE_TYPE_ID),
  CONSTRAINT KM_ATTR_CENSOR_VOCAB_FK 
 FOREIGN KEY (CENSOR_VALUE_ID) 
 REFERENCES COMMON.ATTRIBUTE_VOCABULARY (ATTRIBUTE_VOCABULARY_ID));

ALTER TABLE ${projectName}.HT_FILE_BIOSPECIMEN ADD ( 
	CONSTRAINT HT_FILE_ID_FK 
	FOREIGN KEY (HT_FILE_ID) 
	REFERENCES ${projectName}.HT_FILE(HT_FILE_ID), 
	CONSTRAINT BIOSPECIMEN_ID_FK 
	FOREIGN KEY (BIOSPECIMEN_ID) 
	REFERENCES ${projectName}.BIOSPECIMEN(BIOSPECIMEN_ID));

ALTER TABLE ${projectName}.BIOSPECIMEN ADD ( 
	CONSTRAINT SUBJECT_ID_FK 
	FOREIGN KEY (SUBJECT_ID) 
	REFERENCES ${projectName}.SUBJECT(SUBJECT_ID));

commit;