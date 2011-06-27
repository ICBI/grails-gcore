delete from common.id_mapping where data_source_id = ${id};
delete from common.data_source_content where data_source_id = ${id};
delete from common.data_source_contact where data_source_id = ${id};
delete from guipersist.analysis_study where study_id = ${id};
delete from guipersist.list_study where study_id = ${id};
delete from common.data_source where data_source_id = ${id};