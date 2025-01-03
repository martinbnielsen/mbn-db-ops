
-- Generated by ORDS REST Data Services 24.2.3.r2011847
-- Schema: DBOPS  Date: Fri Oct 25 06:56:48 2024 
--

BEGIN
  ORDS.ENABLE_SCHEMA(
      p_enabled             => TRUE,
      p_schema              => 'DBOPS',
      p_url_mapping_type    => 'BASE_PATH',
      p_url_mapping_pattern => 'dbops',
      p_auto_rest_auth      => FALSE);
    
  ORDS.DEFINE_MODULE(
      p_module_name    => 'DBOPS - Database Operations',
      p_base_path      => '/dbops/',
      p_items_per_page => 25,
      p_status         => 'PUBLISHED',
      p_comments       => NULL);

  ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'DBOPS - Database Operations',
      p_pattern        => 'locks',
      p_priority       => 0,
      p_etag_type      => 'HASH',
      p_etag_query     => NULL,
      p_comments       => 'Database Object Locks');

  ORDS.DEFINE_HANDLER(
      p_module_name    => 'DBOPS - Database Operations',
      p_pattern        => 'locks',
      p_method         => 'GET',
      p_source_type    => 'json/collection',
      p_mimes_allowed  => NULL,
      p_comments       => 'Fetch all database object locks',
      p_source         => 
'select *
from dbops_locks');

    
        
COMMIT;

END;
/