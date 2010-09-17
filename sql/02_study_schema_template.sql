CREATE SEQUENCE ${projectName}.PAV_GROUP_SEQUENCE
  START WITH 100
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;


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


CREATE SEQUENCE ${projectName}.MARRAY_FILE_COLUMN_SEQUENCE
  START WITH 1140
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

CREATE SEQUENCE ${projectName}.HT_RUN_SEQUENCE
  START WITH 1000
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE SEQUENCE ${projectName}.HT_RUN_BIOSPECIMEN_SEQUENCE
  START WITH 1000
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE SEQUENCE ${projectName}.MARRAY_FILE_ROW_SEQUENCE
  START WITH 1000
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;


CREATE SEQUENCE ${projectName}.HT_COLUMN_LINK_SEQ
  START WITH 141
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;


CREATE SEQUENCE ${projectName}.location_value_SEQUENCE
  START WITH 100
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


CREATE TABLE ${projectName}.HT_FILE_COLUMN
(
  HT_FILE_COLUMN_ID  NUMBER(10)                 NOT NULL,
  HT_FILE_ID         NUMBER(10)                 NOT NULL,
  COLUMN_NUMBER      NUMBER(3)                  NOT NULL,
  COLUMN_NAME        VARCHAR2(50 BYTE)          NOT NULL,
  INSERT_USER        VARCHAR2(10 BYTE)          NOT NULL,
  INSERT_DATE        DATE                       NOT NULL,
  INSERT_METHOD      VARCHAR2(20 BYTE)          NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.HT_COLUMN_LINK
(
  HT_COLUMN_LINK_ID      NUMBER(10)             NOT NULL,
  HT_RUN_BIOSPECIMEN_ID  NUMBER(10)             NOT NULL,
  HT_FILE_COLUMN_ID      NUMBER(10)             NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.HT_RUN_BIOSPECIMEN
(
  HT_RUN_BIOSPECIMEN_ID  NUMBER(10)             NOT NULL,
  BIOSPECIMEN_ID         NUMBER(10)             NOT NULL,
  HT_RUN_ID              NUMBER(10)             NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.HT_RUN
(
  HT_RUN_ID        NUMBER(10)                   NOT NULL,
  HT_DESIGN_ID     NUMBER(3)                    NOT NULL,
  RUN_DATE         DATE,
  NAME             VARCHAR2(50 BYTE)            NOT NULL,
  RAW_FILE_ID      NUMBER(8,2),
  INSERT_USER      VARCHAR2(10 BYTE)            NOT NULL,
  INSERT_DATE      DATE                         NOT NULL,
  INSERT_METHOD    VARCHAR2(20 BYTE)            NOT NULL,
  HT_DESIGN_TABLE  VARCHAR2(14 BYTE)            DEFAULT 'HTARRAY_DESIGN'
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.HT_FILE_PRIOR
(
  HT_FILE_ID        NUMBER(10)                  NOT NULL,
  PRIOR_HT_FILE_ID  NUMBER(10)                  NOT NULL
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
  RELATIVE_PATH   VARCHAR2(100 BYTE)            NOT NULL,
  SIZE_B          NUMBER(12)                    NOT NULL,
  FILE_TYPE_ID    NUMBER(3)                     NOT NULL,
  FILE_FORMAT_ID  NUMBER(3)                     NOT NULL,
  DATA_LEVEL      VARCHAR2(15 BYTE)             NOT NULL,
  INSERT_USER     VARCHAR2(20 BYTE)             NOT NULL,
  INSERT_DATE     DATE                          NOT NULL,
  INSERT_METHOD   VARCHAR2(20 BYTE)             NOT NULL,
  DESCRIPTION     VARCHAR2(100 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


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


CREATE TABLE ${projectName}.BIOSPECIMEN_ATTRIBUTE_VALUE
(
  BIOSPEC_ATTRIBUTE_VALUE_ID  NUMBER(10)        NOT NULL,
  BIOSPECIMEN_ID              NUMBER(10)        NOT NULL,
  ATTRIBUTE_TYPE_ID           NUMBER(10)        NOT NULL,
  VALUE                       VARCHAR2(100 BYTE) NOT NULL,
  INSERT_USER                 VARCHAR2(20 BYTE) NOT NULL,
  INSERT_DATE                 DATE              NOT NULL,
  INSERT_METHOD               VARCHAR2(20 BYTE) NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.ATTRIBUTE_STATS
(
  ATTRIBUTE_TYPE_ID  NUMBER(10)                 NOT NULL,
  NULLABLE           NUMBER(1)                  NOT NULL,
  SINGLE_VALUE       NUMBER(1)                  NOT NULL,
  NOTES              VARCHAR2(255 BYTE),
  COVERAGE           NUMBER(4,1),
  USABLE_COVERAGE    NUMBER(4,1),
  USABLE_SQL         VARCHAR2(255 BYTE),
  TABLE_NAME         VARCHAR2(30 BYTE)          NOT NULL,
  INSERT_USER        VARCHAR2(10 BYTE)          NOT NULL,
  INSERT_DATE        DATE                       NOT NULL,
  INSERT_METHOD      VARCHAR2(20 BYTE)          NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.ATTRIBUTE_TIMEPOINT
(
  ATTRIBUTE_TIMEPOINT_ID  NUMBER(10)            NOT NULL,
  SERIES_ID               NUMBER(5)             NOT NULL,
  TIMEPOINT               NUMBER(3)             NOT NULL,
  TAG                     VARCHAR2(25 BYTE),
  INSERT_USER             VARCHAR2(10 BYTE)     NOT NULL,
  INSERT_DATE             DATE                  NOT NULL,
  INSERT_METHOD           VARCHAR2(20 BYTE)     NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.PATIENT
(
  PATIENT_ID               NUMBER(10)           NOT NULL,
  DATA_SOURCE_INTERNAL_ID  VARCHAR2(15 BYTE)    NOT NULL,
  INSERT_USER              VARCHAR2(10 BYTE)    NOT NULL,
  INSERT_DATE              DATE                 NOT NULL,
  INSERT_METHOD            VARCHAR2(20 BYTE)    NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.ORIGINAL_ATTRIBUTE
(
  ATTRIBUTE_TYPE_ID  NUMBER(10)                 NOT NULL,
  NAME               VARCHAR2(200 BYTE)         NOT NULL,
  CONVERSION_NOTE    VARCHAR2(255 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.PATIENT_ATTRIBUTE_VALUE
(
  PATIENT_ATTRIBUTE_VALUE_ID  NUMBER(10)        NOT NULL,
  PATIENT_ID                  NUMBER(10)        NOT NULL,
  ATTRIBUTE_TYPE_ID           NUMBER(10)        NOT NULL,
  VALUE                       VARCHAR2(100 BYTE) NOT NULL,
  GROUP_NUMBER                NUMBER(8),
  ATTRIBUTE_TIMEPOINT_ID      NUMBER(10),
  AGE_AT_EVENT                NUMBER(3,1),
  INSERT_USER                 VARCHAR2(10 BYTE) NOT NULL,
  INSERT_DATE                 DATE              NOT NULL,
  INSERT_METHOD               VARCHAR2(20 BYTE) NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.BIOSPECIMEN
(
  BIOSPECIMEN_ID          NUMBER(10)            NOT NULL,
  CLASS                   VARCHAR2(20 BYTE)     NOT NULL,
  NAME                    VARCHAR2(50 BYTE)     NOT NULL,
  PATIENT_ID              NUMBER(10)            NOT NULL,
  BIOSPECIMEN_PARENT_ID   NUMBER(10),
  PROTOCOL_ID             NUMBER(4),
  DISEASED                NUMBER(1)             NOT NULL,
  INSERT_USER             VARCHAR2(20 BYTE)     NOT NULL,
  INSERT_DATE             DATE                  NOT NULL,
  INSERT_METHOD           VARCHAR2(20 BYTE)     NOT NULL,
  ATTRIBUTE_TIMEPOINT_ID  NUMBER(10)            DEFAULT 0                     NOT NULL,
  AGE_AT_EVENT            NUMBER(3,1)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE ${projectName}.SCHEMA_CONFIGURATION
(
  SCHEMA_VERSION  NUMBER(3)                     NOT NULL,
  SCHEMA_DATE     DATE                          NOT NULL,
  SCHEMA_NOTES    VARCHAR2(2000 BYTE)
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

create table  ${projectName}.location_value 
  (id number(19,0) not null, 
  version number(19,0), 
  chromosome varchar2(255) not null,
  start_position double precision not null,
  end_position double precision not null, 
  reduction_analysis_id number(19,0) not null,  
  value double precision not null
 )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX  ${projectName}.reduction_analysis_PK ON ${projectName}.reduction_analysis
(ID)
LOGGING
NOPARALLEL;

CREATE UNIQUE INDEX  ${projectName}.location_value_PK ON ${projectName}.location_value
(ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.SCHEMA_CONFIGURATION_PK ON ${projectName}.SCHEMA_CONFIGURATION
(SCHEMA_VERSION)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.BIOSPECIMEN_PK ON ${projectName}.BIOSPECIMEN
(BIOSPECIMEN_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.PATIENT_ATTRIBUTE_VALUE_PK ON ${projectName}.PATIENT_ATTRIBUTE_VALUE
(PATIENT_ATTRIBUTE_VALUE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.ORIGINAL_ATTRIBUTE_PK ON ${projectName}.ORIGINAL_ATTRIBUTE
(ATTRIBUTE_TYPE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.PATIENT_PK ON ${projectName}.PATIENT
(PATIENT_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.ATTRIBUTE_TIMEPOINT_PK ON ${projectName}.ATTRIBUTE_TIMEPOINT
(ATTRIBUTE_TIMEPOINT_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.BIOSPECIMEN_NAME_AK ON ${projectName}.BIOSPECIMEN
(NAME)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.PAV_VALUE_AK1 ON ${projectName}.PATIENT_ATTRIBUTE_VALUE
(PATIENT_ID, ATTRIBUTE_TYPE_ID, ATTRIBUTE_TIMEPOINT_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.PAV_VALUE_AK2 ON ${projectName}.PATIENT_ATTRIBUTE_VALUE
(GROUP_NUMBER, PATIENT_ID, ATTRIBUTE_TYPE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.PATIENT_AK1 ON ${projectName}.PATIENT
(DATA_SOURCE_INTERNAL_ID)
LOGGING
NOPARALLEL;


CREATE INDEX ${projectName}.PAV_TYPE_VALUE_IDX ON ${projectName}.PATIENT_ATTRIBUTE_VALUE
(ATTRIBUTE_TYPE_ID, VALUE)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.ATT_STATS_PK ON ${projectName}.ATTRIBUTE_STATS
(ATTRIBUTE_TYPE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.BAV_PK ON ${projectName}.BIOSPECIMEN_ATTRIBUTE_VALUE
(BIOSPEC_ATTRIBUTE_VALUE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MARRAY_FILE_PK ON ${projectName}.HT_FILE
(HT_FILE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MARRAY_FILE_PRIOR_PK ON ${projectName}.HT_FILE_PRIOR
(HT_FILE_ID, PRIOR_HT_FILE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.KM_ATTRIBUTE_PK ON ${projectName}.KM_ATTRIBUTE
(KM_ATTRIBUTE_ID, CENSOR_ATTRIBUTE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.BAV_AK ON ${projectName}.BIOSPECIMEN_ATTRIBUTE_VALUE
(BIOSPECIMEN_ID, ATTRIBUTE_TYPE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.MARRAY_FILE_NAME_AK ON ${projectName}.HT_FILE
(NAME)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.HT_RUN_IMAGE_AK ON ${projectName}.HT_RUN
(RAW_FILE_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.HT_RUN_NAME_AK ON ${projectName}.HT_RUN
(NAME)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.HT_RUN_PK ON ${projectName}.HT_RUN
(HT_RUN_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.HT_RUN_BIOSPECIMEN_PK ON ${projectName}.HT_RUN_BIOSPECIMEN
(HT_RUN_BIOSPECIMEN_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.HT_RUN_BIOSPEC_AK ON ${projectName}.HT_RUN_BIOSPECIMEN
(BIOSPECIMEN_ID, HT_RUN_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.HT_COLUMN_LINK_PK ON ${projectName}.HT_COLUMN_LINK
(HT_COLUMN_LINK_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.HT_COLUMN_LINK_AK ON ${projectName}.HT_COLUMN_LINK
(HT_RUN_BIOSPECIMEN_ID, HT_FILE_COLUMN_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX ${projectName}.HT_FILE_COLUMN_PK ON ${projectName}.HT_FILE_COLUMN
(HT_FILE_COLUMN_ID)
LOGGING
NOPARALLEL;


CREATE INDEX ${projectName}.HT_FILE_COLUMN_AK ON ${projectName}.HT_FILE_COLUMN
(HT_FILE_ID, COLUMN_NUMBER)
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

CREATE INDEX ${projectName}.PATIENT_ATTRIBUTE_VALUE_INDEX1 ON ${projectName}.PATIENT_ATTRIBUTE_VALUE
(ATTRIBUTE_TYPE_ID ASC)
LOGGING
NOPARALLEL;

CREATE INDEX ${projectName}.BIOSPECIMEN_ATT_VALUE_INDEX1 ON ${projectName}.BIOSPECIMEN_ATTRIBUTE_VALUE
(ATTRIBUTE_TYPE_ID ASC)
LOGGING
NOPARALLEL;


CREATE OR REPLACE VIEW ${projectName}.PATIENTS
AS 
select c.gdoc_id, s.patient_id, s.data_source_internal_id
from common.patient_data_source c, ${projectName}.patient s
where s.patient_id = c.patient_id;


CREATE OR REPLACE VIEW ${projectName}.USED_ATTRIBUTES
AS 
SELECT distinct c.attribute_type_id, o.name as original_name, o.conversion_note, c.short_name, c.long_name, c.definition, c.class, c.semantic_group, c.gdoc_preferred, c.cadsr_id, c.evs_id, c.qualitative, c.continuous, c.vocabulary, c.oracle_datatype, c.unit, c.upper_range, c.lower_range, 'PATIENT' as target
FROM (common.attribute_type c
       left outer join ${projectName}.original_attribute o
       on o.attribute_type_id = c.attribute_type_id
     ) inner join ${projectName}.patient_attribute_value v
       on v.attribute_type_id = c.attribute_type_id
UNION
SELECT distinct c.attribute_type_id, o.name as original_name, o.conversion_note, c.short_name, c.long_name, c.definition, c.class, c.semantic_group, c.gdoc_preferred, c.cadsr_id, c.evs_id, c.qualitative, c.continuous, c.vocabulary, c.oracle_datatype, c.unit, c.upper_range, c.lower_range, 'BIOSPECIMEN' as target
FROM (common.attribute_type c
	       left outer join ${projectName}.original_attribute o
	       on o.attribute_type_id = c.attribute_type_id
	     ) inner join ${projectName}.biospecimen_attribute_value v
	       on v.attribute_type_id = c.attribute_type_id
WITH READ ONLY;


CREATE OR REPLACE VIEW ${projectName}.KM_ATTRIBUTES
AS 
select k.long_name KM_ATTRIBUTE, k.short_name KM_ATTRIBUTE_SHORT, c.long_name CENSOR_ATTRIBUTE, c.short_name CENSOR_ATTRIBUTE_SHORT , v.term CENSOR_VALUE
from ${projectName}.km_attribute km, attribute_type k, attribute_type c, attribute_vocabulary v
where km.km_attribute_id = k.attribute_type_id
and km.censor_attribute_id = c.attribute_type_id
and km.censor_value_id = v.attribute_vocabulary_id
WITH READ ONLY;


CREATE OR REPLACE VIEW ${projectName}.HT_FILE_CONTENTS
AS 
SELECT   ROWNUM id, f.name file_name, b.biospecimen_id biospecimen_id, b.name biospecimen_name, d.ARRAY_TYPE design_type, d.htarray_design_id design_id
     FROM   ${projectName}.ht_file_prior p,
            ${projectName}.ht_file f,
            ${projectName}.ht_run_biospecimen r,
            ${projectName}.biospecimen b,
            common.all_designs d,
            ${projectName}.ht_run hr
    WHERE   P.ht_file_id = F.ht_FILE_ID
            AND r.biospecimen_id = b.biospecimen_id
            AND d.HTARRAY_DESIGN_ID = hr.ht_design_id
            AND hr.ht_run_id = r.ht_run_id
            AND hr.raw_file_id = p.prior_ht_file_id
   WITH READ ONLY;


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

ALTER TABLE ${projectName}.HT_FILE_COLUMN ADD (
  CONSTRAINT MARRAY_FILE_COLUMN_PK
 PRIMARY KEY
 (HT_FILE_COLUMN_ID));

ALTER TABLE ${projectName}.HT_COLUMN_LINK ADD (
  CONSTRAINT HT_COLUMN_LINK_PK
 PRIMARY KEY
 (HT_COLUMN_LINK_ID));

ALTER TABLE ${projectName}.HT_RUN_BIOSPECIMEN ADD (
  CONSTRAINT MARRAY_RUN_BIOSPECIMEN_PK
 PRIMARY KEY
 (HT_RUN_BIOSPECIMEN_ID));

ALTER TABLE ${projectName}.HT_RUN ADD (
  CONSTRAINT HT_RUN_DESIGN_TABLE_CC
 CHECK (HT_DESIGN_TABLE IN ('HTARRAY_DESIGN', 'MS_DESIGN')),
  CONSTRAINT HT_RUN_PK
 PRIMARY KEY
 (HT_RUN_ID));

ALTER TABLE ${projectName}.HT_FILE_PRIOR ADD (
  CONSTRAINT MARRAY_FILE_PRIOR_PK
 PRIMARY KEY
 (HT_FILE_ID, PRIOR_HT_FILE_ID));

ALTER TABLE ${projectName}.HT_FILE ADD (
  CONSTRAINT HT_FILE_LEVEL_CC
 CHECK (data_level in ('RAW','NORMALIZED','INTERPRETED','ROI')),
  CONSTRAINT HT_FILE_PK
 PRIMARY KEY
 (HT_FILE_ID));

ALTER TABLE ${projectName}.KM_ATTRIBUTE ADD (
  CONSTRAINT KM_ATTRIBUTE_PK
 PRIMARY KEY
 (KM_ATTRIBUTE_ID, CENSOR_ATTRIBUTE_ID));

ALTER TABLE ${projectName}.BIOSPECIMEN_ATTRIBUTE_VALUE ADD (
  CONSTRAINT BAV_PK
 PRIMARY KEY
 (BIOSPEC_ATTRIBUTE_VALUE_ID));

ALTER TABLE ${projectName}.ATTRIBUTE_STATS ADD (
  CONSTRAINT ATT_STATS_COVERAGE_CC
 CHECK (coverage between 0 and 100),
  CONSTRAINT ATT_STATS_NULLABLE_CC
 CHECK (nullable in (0,1)),
  CONSTRAINT ATT_STATS_SINGLE_VALUE_CC
 CHECK (single_value in (0,1)),
  CONSTRAINT ATT_STATS_TABLE_CC
 CHECK (table_name in ('PATIENT_ATTRIBUTE_VALUE','BIOSPECIMEN_ATTRIBUTE_VALUE')),
  CONSTRAINT ATT_STATS_U_COVERAGE_CC
 CHECK (usable_coverage between 0 and 100),
  CONSTRAINT ATT_STATS_PK
 PRIMARY KEY
 (ATTRIBUTE_TYPE_ID));

ALTER TABLE ${projectName}.ATTRIBUTE_TIMEPOINT ADD (
  CONSTRAINT ATTRIBUTE_TIMEPOINT_PK
 PRIMARY KEY
 (ATTRIBUTE_TIMEPOINT_ID));

ALTER TABLE ${projectName}.PATIENT ADD (
  CONSTRAINT PATIENT_PK
 PRIMARY KEY
 (PATIENT_ID));

ALTER TABLE ${projectName}.ORIGINAL_ATTRIBUTE ADD (
  CONSTRAINT ORIGINAL_ATTRIBUTE_PK
 PRIMARY KEY
 (ATTRIBUTE_TYPE_ID));

ALTER TABLE ${projectName}.PATIENT_ATTRIBUTE_VALUE ADD (
  CONSTRAINT PATIENT_ATTRIBUTE_VALUE_PK
 PRIMARY KEY
 (PATIENT_ATTRIBUTE_VALUE_ID));

ALTER TABLE ${projectName}.BIOSPECIMEN ADD (
  CONSTRAINT BIOSPECIMEN_CLASS_CC
 CHECK (class in ('SAMPLE','EXTRACT','LABELED_EXTRACT')),
  CONSTRAINT BIOSPECIMEN_PK
 PRIMARY KEY
 (BIOSPECIMEN_ID));

ALTER TABLE ${projectName}.SCHEMA_CONFIGURATION ADD (
  CONSTRAINT SCHEMA_CONFIGURATION_PK
 PRIMARY KEY
 (SCHEMA_VERSION));

ALTER TABLE ${projectName}.reduction_analysis add (
 	CONSTRAINT reduction_analysis_pk
	PRIMARY KEY
	(ID)); 

ALTER TABLE ${projectName}.location_value add (
	 CONSTRAINT location_value_pk
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

ALTER TABLE ${projectName}.HT_FILE_COLUMN ADD (
  CONSTRAINT HT_FILE_COLUMN_FILE_FK 
 FOREIGN KEY (HT_FILE_ID) 
 REFERENCES ${projectName}.HT_FILE (HT_FILE_ID));

ALTER TABLE ${projectName}.HT_COLUMN_LINK ADD (
  CONSTRAINT HCL_RUN_BIOSPEC_FK 
 FOREIGN KEY (HT_RUN_BIOSPECIMEN_ID) 
 REFERENCES ${projectName}.HT_RUN_BIOSPECIMEN (HT_RUN_BIOSPECIMEN_ID),
  CONSTRAINT HCL_FILE_COL_FK 
 FOREIGN KEY (HT_FILE_COLUMN_ID) 
 REFERENCES ${projectName}.HT_FILE_COLUMN (HT_FILE_COLUMN_ID));

ALTER TABLE ${projectName}.HT_RUN_BIOSPECIMEN ADD (
  CONSTRAINT HRB_BIOSPECIMEN_FK 
 FOREIGN KEY (BIOSPECIMEN_ID) 
 REFERENCES ${projectName}.BIOSPECIMEN (BIOSPECIMEN_ID),
  CONSTRAINT HRB_HT_RUN_FK 
 FOREIGN KEY (HT_RUN_ID) 
 REFERENCES ${projectName}.HT_RUN (HT_RUN_ID));

ALTER TABLE ${projectName}.HT_RUN ADD (
  CONSTRAINT HT_RUN_FILE_FK 
 FOREIGN KEY (RAW_FILE_ID) 
 REFERENCES ${projectName}.HT_FILE (HT_FILE_ID));

ALTER TABLE ${projectName}.HT_FILE_PRIOR ADD (
  CONSTRAINT HT_FILE_PRIOR_CHILD_FK 
 FOREIGN KEY (HT_FILE_ID) 
 REFERENCES ${projectName}.HT_FILE (HT_FILE_ID),
  CONSTRAINT HT_FILE_PRIOR_PARENT_FK 
 FOREIGN KEY (PRIOR_HT_FILE_ID) 
 REFERENCES ${projectName}.HT_FILE (HT_FILE_ID));

ALTER TABLE ${projectName}.HT_FILE ADD (
  CONSTRAINT MARRAY_FILE_FORMAT_FK 
 FOREIGN KEY (FILE_FORMAT_ID) 
 REFERENCES COMMON.FILE_FORMAT (FILE_FORMAT_ID),
  CONSTRAINT MARRAY_FILE_TYPE_FK 
 FOREIGN KEY (FILE_TYPE_ID) 
 REFERENCES COMMON.FILE_TYPE (FILE_TYPE_ID));

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

ALTER TABLE ${projectName}.BIOSPECIMEN_ATTRIBUTE_VALUE ADD (
  CONSTRAINT BAV_BIOSPECIMEN_FK 
 FOREIGN KEY (BIOSPECIMEN_ID) 
 REFERENCES ${projectName}.BIOSPECIMEN (BIOSPECIMEN_ID),
  CONSTRAINT BAV_ATTRIBUTE_TYPE_FK 
 FOREIGN KEY (ATTRIBUTE_TYPE_ID) 
 REFERENCES COMMON.ATTRIBUTE_TYPE (ATTRIBUTE_TYPE_ID));

ALTER TABLE ${projectName}.ATTRIBUTE_STATS ADD (
  CONSTRAINT ATT_STATS_ATT_TYPE_FK 
 FOREIGN KEY (ATTRIBUTE_TYPE_ID) 
 REFERENCES COMMON.ATTRIBUTE_TYPE (ATTRIBUTE_TYPE_ID));

ALTER TABLE ${projectName}.ORIGINAL_ATTRIBUTE ADD (
  CONSTRAINT OA_ATTRIBUTE_TYPE_FK 
 FOREIGN KEY (ATTRIBUTE_TYPE_ID) 
 REFERENCES COMMON.ATTRIBUTE_TYPE (ATTRIBUTE_TYPE_ID));

ALTER TABLE ${projectName}.PATIENT_ATTRIBUTE_VALUE ADD (
  CONSTRAINT PAV_PATIENT_FK 
 FOREIGN KEY (PATIENT_ID) 
 REFERENCES ${projectName}.PATIENT (PATIENT_ID),
  CONSTRAINT PAV_ATTRIBUTE_TYPE_FK 
 FOREIGN KEY (ATTRIBUTE_TYPE_ID) 
 REFERENCES COMMON.ATTRIBUTE_TYPE (ATTRIBUTE_TYPE_ID),
  CONSTRAINT PAV_TIMEPOINT_FK 
 FOREIGN KEY (ATTRIBUTE_TIMEPOINT_ID) 
 REFERENCES ${projectName}.ATTRIBUTE_TIMEPOINT (ATTRIBUTE_TIMEPOINT_ID));

ALTER TABLE ${projectName}.BIOSPECIMEN ADD (
  CONSTRAINT BIOSPECIMEN_TIMPOINT_FK 
 FOREIGN KEY (ATTRIBUTE_TIMEPOINT_ID) 
 REFERENCES ${projectName}.ATTRIBUTE_TIMEPOINT (ATTRIBUTE_TIMEPOINT_ID),
  CONSTRAINT BIOSPECIMEN_PATIENT_FK 
 FOREIGN KEY (PATIENT_ID) 
 REFERENCES ${projectName}.PATIENT (PATIENT_ID),
  CONSTRAINT BIOSPECIMEN_PARENT_FK 
 FOREIGN KEY (BIOSPECIMEN_PARENT_ID) 
 REFERENCES ${projectName}.BIOSPECIMEN (BIOSPECIMEN_ID),
  CONSTRAINT BIOSPECIMEN_PROTOCOL_FK 
 FOREIGN KEY (PROTOCOL_ID) 
 REFERENCES COMMON.PROTOCOL (PROTOCOL_ID));

alter table ${projectName}.location_value add (
	constraint lv_reduction_analysis_link_fk 
	foreign key (reduction_analysis_id) 
  	references ${projectName}.reduction_analysis);

Insert into ${projectName}.ATTRIBUTE_TIMEPOINT (ATTRIBUTE_TIMEPOINT_ID,SERIES_ID,TIMEPOINT,TAG,INSERT_USER,INSERT_DATE,INSERT_METHOD) values (0,0,0,'DEFAULT TIMEPOINT','USER',(SELECT SYSDATE FROM dual) ,'manual');

commit;