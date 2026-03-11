'''
- uri: URI of the REST API end point for data extraction
- table: target Datamart table
- origin: For datamart.sh or datamart.bat sccript, 'hd' if endpoint is Health Dashboard (ie AAD), 'ed' if endpoint is Engineering Dashoard
- nb_primary_columns: number of fist columns that form a primary key. This value is used to detect duplicate rows on some measurement bases
- column_name: the column name used by the 'DELETE FROM WHERE' SQL statement to replace data (script: datamart update)
- env: Required environment variables
'''

DATAMART = [
  {'uri': 'datamart/dim-snapshots',                  'table': 'DIM_SNAPSHOTS',                    'origin': 'hd', 'nb_primary_columns': 1, 'env': None},
  {'uri': 'datamart/dim-rules',                      'table': 'DIM_RULES',                        'origin': 'hd', 'nb_primary_columns': 1, 'env': None},
  {'uri': 'datamart/dim-omg-rules',                  'table': 'DIM_OMG_RULES',                    'origin': 'hd', 'nb_primary_columns': 1, 'env': None},
  {'uri': 'datamart/dim-cisq-rules',                 'table': 'DIM_CISQ_RULES',                   'origin': 'hd', 'nb_primary_columns': 1, 'env': None},
  {'uri': 'datamart/dim-applications',               'table': 'DIM_APPLICATIONS',                 'origin': 'hd', 'nb_primary_columns': -1, 'env': None},
  {'uri': 'datamart/app-violations-measures',        'table': 'APP_VIOLATIONS_MEASURES',          'origin': 'hd', 'nb_primary_columns': 3, 'env': None},
  {'uri': 'datamart/app-violations-evolution',       'table': 'APP_VIOLATIONS_EVOLUTION',         'origin': 'hd', 'nb_primary_columns': 3, 'env': None},
  {'uri': 'datamart/app-sizing-measures',            'table': 'APP_SIZING_MEASURES',              'origin': 'hd', 'nb_primary_columns': 1, 'env': None},
  {'uri': 'datamart/app-functional-sizing-measures', 'table': 'APP_FUNCTIONAL_SIZING_MEASURES',   'origin': 'hd', 'nb_primary_columns': 1, 'env': None},
  {'uri': 'datamart/app-health-scores',              'table': 'APP_HEALTH_SCORES',                'origin': 'hd', 'nb_primary_columns': 2, 'env': None},
  {'uri': 'datamart/app-scores',                     'table': 'APP_SCORES',                       'origin': 'hd', 'nb_primary_columns': 2, 'env': None},
  {'uri': 'datamart/app-sizing-evolution',           'table': 'APP_SIZING_EVOLUTION',             'origin': 'hd', 'nb_primary_columns': 1, 'env': None},
  {'uri': 'datamart/app-functional-sizing-evolution','table': 'APP_FUNCTIONAL_SIZING_EVOLUTION',  'origin': 'hd', 'nb_primary_columns': 1, 'env': None},
  {'uri': 'datamart/app-health-evolution',           'table': 'APP_HEALTH_EVOLUTION',             'origin': 'hd', 'nb_primary_columns': 3, 'env': None},
  {'uri': 'datamart/std-rules',                      'table': 'STD_RULES',                        'origin': 'hd', 'nb_primary_columns': 3, 'env': None},
  {'uri': 'datamart/std-descriptions',               'table': 'STD_DESCRIPTIONS',                 'origin': 'hd', 'nb_primary_columns': 0, 'env': None},
   
  {'uri': 'datamart/app-techno-sizing-measures',     'table': 'APP_TECHNO_SIZING_MEASURES',       'origin': 'hd', 'nb_primary_columns': 2, 'env': {'EXTRACT_TECHNO': 'ON'}},
  {'uri': 'datamart/app-techno-scores',              'table': 'APP_TECHNO_SCORES',                'origin': 'hd', 'nb_primary_columns': 3, 'env': {'EXTRACT_TECHNO': 'ON'}},
  {'uri': 'datamart/app-techno-sizing-evolution',    'table': 'APP_TECHNO_SIZING_EVOLUTION',      'origin': 'hd', 'nb_primary_columns': 3, 'env': {'EXTRACT_TECHNO': 'ON'}},
   
  {'uri': 'datamart/mod-violations-measures',        'table': 'MOD_VIOLATIONS_MEASURES',          'origin': 'hd', 'nb_primary_columns': 4, 'env': {'EXTRACT_MOD': 'ON'}},
  {'uri': 'datamart/mod-violations-evolution',       'table': 'MOD_VIOLATIONS_EVOLUTION',         'origin': 'hd', 'nb_primary_columns': 4, 'env': {'EXTRACT_MOD': 'ON'}},
  {'uri': 'datamart/mod-sizing-measures',            'table': 'MOD_SIZING_MEASURES',              'origin': 'hd', 'nb_primary_columns': 2, 'env': {'EXTRACT_MOD': 'ON'}},
  {'uri': 'datamart/mod-health-scores',              'table': 'MOD_HEALTH_SCORES',                'origin': 'hd', 'nb_primary_columns': 3, 'env': {'EXTRACT_MOD': 'ON'}},
  {'uri': 'datamart/mod-scores',                     'table': 'MOD_SCORES',                       'origin': 'hd', 'nb_primary_columns': 3, 'env': {'EXTRACT_MOD': 'ON'}},
  {'uri': 'datamart/mod-sizing-evolution',           'table': 'MOD_SIZING_EVOLUTION',             'origin': 'hd', 'nb_primary_columns': 3, 'env': {'EXTRACT_MOD': 'ON'}},
  {'uri': 'datamart/mod-health-evolution',           'table': 'MOD_HEALTH_EVOLUTION',             'origin': 'hd', 'nb_primary_columns': 4, 'env': {'EXTRACT_MOD': 'ON'}},

  {'uri': 'datamart/mod-techno-sizing-measures',     'table': 'MOD_TECHNO_SIZING_MEASURES',       'origin': 'hd', 'nb_primary_columns': 3, 'env': {'EXTRACT_TECHNO': 'ON', 'EXTRACT_MOD': 'ON'}},
  {'uri': 'datamart/mod-techno-scores',              'table': 'MOD_TECHNO_SCORES',                'origin': 'hd', 'nb_primary_columns': 4, 'env': {'EXTRACT_TECHNO': 'ON', 'EXTRACT_MOD': 'ON'}},
  {'uri': 'datamart/mod-techno-sizing-evolution',    'table': 'MOD_TECHNO_SIZING_EVOLUTION',      'origin': 'hd', 'nb_primary_columns': 4, 'env': {'EXTRACT_TECHNO': 'ON', 'EXTRACT_MOD': 'ON'}},
  
  {'uri': 'datamart/app-findings-measures',          'table': 'APP_FINDINGS_MEASURES',            'origin': 'ed', 'nb_primary_columns': 0, 'column_name': 'snapshot_id',     'env': None},
  
  {'uri': 'datamart/usr-exclusions',                 'table': 'USR_EXCLUSIONS',                   'origin': 'ed', 'nb_primary_columns': 0, 'column_name': 'application_name', 'env': {'EXTRACT_USR': 'ON'}},
  {'uri': 'datamart/usr-action-plan',                'table': 'USR_ACTION_PLAN',                  'origin': 'ed', 'nb_primary_columns': 0, 'column_name': 'application_name', 'env': {'EXTRACT_USR': 'ON'}},

  {'uri': 'datamart/src-objects',                    'table': 'SRC_OBJECTS',                      'origin': 'ed', 'nb_primary_columns': 2, 'column_name': 'application_name', 'env': {'EXTRACT_SRC': 'ON'}},
  {'uri': 'datamart/src-transactions',               'table': 'SRC_TRANSACTIONS',                 'origin': 'ed', 'nb_primary_columns': 2, 'column_name': 'application_name', 'env': {'EXTRACT_SRC': 'ON'}},
  {'uri': 'datamart/src-trx-objects',                'table': 'SRC_TRX_OBJECTS',                  'origin': 'ed', 'nb_primary_columns': 2, 'column_name': 'object_id',        'env': {'EXTRACT_SRC': 'ON'}},
  {'uri': 'datamart/src-health-impacts',             'table': 'SRC_HEALTH_IMPACTS',               'origin': 'ed', 'nb_primary_columns': 4, 'column_name': 'object_id',        'env': {'EXTRACT_SRC': 'ON'}},
  {'uri': 'datamart/src-trx-health-impacts',         'table': 'SRC_TRX_HEALTH_IMPACTS',           'origin': 'ed', 'nb_primary_columns': 3, 'column_name': 'application_name', 'env': {'EXTRACT_SRC': 'ON'}},
  {'uri': 'datamart/src-violations',                 'table': 'SRC_VIOLATIONS',                   'origin': 'ed', 'nb_primary_columns': 5, 'column_name': 'object_id',        'env': {'EXTRACT_SRC': 'ON'}},

  {'uri': 'datamart/src-mod-objects',                'table': 'SRC_MOD_OBJECTS',                  'origin': 'ed', 'nb_primary_columns': 3, 'column_name': 'application_name', 'env': {'EXTRACT_SRC': 'ON', 'EXTRACT_MOD': 'ON'}},
]