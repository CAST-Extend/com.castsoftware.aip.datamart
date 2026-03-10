DATAMART = [
  {'uri':'datamart/dim-snapshots',                  'table':'DIM_SNAPSHOTS',                    'env': None, 'origin': 'hd'},
  {'uri':'datamart/dim-rules',                      'table':'DIM_RULES',                        'env': None, 'origin': 'hd'},
  {'uri':'datamart/dim-omg-rules',                  'table':'DIM_OMG_RULES',                    'env': None, 'origin': 'hd'},
  {'uri':'datamart/dim-cisq-rules',                 'table':'DIM_CISQ_RULES',                   'env': None, 'origin': 'hd'},
  {'uri':'datamart/dim-applications',               'table':'DIM_APPLICATIONS',                 'env': None, 'origin': 'hd'},
  {'uri':'datamart/app-violations-measures',        'table':'APP_VIOLATIONS_MEASURES',          'env': None, 'origin': 'hd'},
  {'uri':'datamart/app-violations-evolution',       'table':'APP_VIOLATIONS_EVOLUTION',         'env': None, 'origin': 'hd'},
  {'uri':'datamart/app-sizing-measures',            'table':'APP_SIZING_MEASURES',              'env': None, 'origin': 'hd'},
  {'uri':'datamart/app-functional-sizing-measures', 'table':'APP_FUNCTIONAL_SIZING_MEASURES',   'env': None, 'origin': 'hd'},
  {'uri':'datamart/app-health-scores',              'table':'APP_HEALTH_SCORES',                'env': None, 'origin': 'hd'},
  {'uri':'datamart/app-scores',                     'table':'APP_SCORES',                       'env': None, 'origin': 'hd'},
  {'uri':'datamart/app-sizing-evolution',           'table':'APP_SIZING_EVOLUTION',             'env': None, 'origin': 'hd'},
  {'uri':'datamart/app-functional-sizing-evolution','table':'APP_FUNCTIONAL_SIZING_EVOLUTION',  'env': None, 'origin': 'hd'},
  {'uri':'datamart/app-health-evolution',           'table':'APP_HEALTH_EVOLUTION',             'env': None, 'origin': 'hd'},
  {'uri':'datamart/std-rules',                      'table':'STD_RULES',                        'env': None, 'origin': 'hd'},
  {'uri':'datamart/std-descriptions',               'table':'STD_DESCRIPTIONS',                 'env': None, 'origin': 'hd'},
   
  {'uri':'datamart/app-techno-sizing-measures',     'table':'APP_TECHNO_SIZING_MEASURES',       'env': {'EXTRACT_TECHNO': 'ON'}, 'origin':'hd'},
  {'uri':'datamart/app-techno-sizing-evolution',    'table':'APP_TECHNO_SIZING_EVOLUTION',      'env': {'EXTRACT_TECHNO': 'ON'}, 'origin':'hd'},
   
  {'uri':'datamart/mod-violations-measures',        'table':'MOD_VIOLATIONS_MEASURES',          'env': {'EXTRACT_MOD': 'ON'}, 'origin':'hd'},
  {'uri':'datamart/mod-violations-evolution',       'table':'MOD_VIOLATIONS_EVOLUTION',         'env': {'EXTRACT_MOD': 'ON'}, 'origin':'hd'},
  {'uri':'datamart/mod-sizing-measures',            'table':'MOD_SIZING_MEASURES',              'env': {'EXTRACT_MOD': 'ON'}, 'origin':'hd'},
  {'uri':'datamart/mod-health-scores',              'table':'MOD_HEALTH_SCORES',                'env': {'EXTRACT_MOD': 'ON'}, 'origin':'hd'},
  {'uri':'datamart/mod-scores',                     'table':'MOD_SCORES',                       'env': {'EXTRACT_MOD': 'ON'}, 'origin':'hd'},
  {'uri':'datamart/mod-sizing-evolution',           'table':'MOD_SIZING_EVOLUTION',             'env': {'EXTRACT_MOD': 'ON'}, 'origin':'hd'},
  {'uri':'datamart/mod-health-evolution',           'table':'MOD_HEALTH_EVOLUTION',             'env': {'EXTRACT_MOD': 'ON'}, 'origin':'hd'},

  {'uri':'datamart/mod-techno-sizing-measures',     'table':'MOD_TECHNO_SIZING_MEASURES',       'env': {'EXTRACT_TECHNO': 'ON', 'EXTRACT_MOD': 'ON'}, 'origin':'hd'},
  {'uri':'datamart/mod-techno-scores',              'table':'MOD_TECHNO_SCORES',                'env': {'EXTRACT_TECHNO': 'ON', 'EXTRACT_MOD': 'ON'}, 'origin':'hd'},
  {'uri':'datamart/mod-techno-sizing-evolution',    'table':'MOD_TECHNO_SIZING_EVOLUTION',      'env': {'EXTRACT_TECHNO': 'ON', 'EXTRACT_MOD': 'ON'}, 'origin':'hd'},
  
  {'uri':'datamart/app-findings-measures',          'table':'APP_FINDINGS_MEASURES',            'env': None, 'origin': 'ed'},
  
  {'uri':'datamart/usr-exclusions',                 'table':'USR_EXCLUSIONS',                   'env': {'EXTRACT_USR': 'ON'}, 'origin':'ed'},
  {'uri':'datamart/usr-action-plan',                'table':'USR_ACTION_PLAN',                  'env': {'EXTRACT_USR': 'ON'}, 'origin':'ed'},

  {'uri':'datamart/src-objects',                    'table':'SRC_OBJECTS',                      'env': {'EXTRACT_SRC': 'ON'}, 'origin':'ed'},
  {'uri':'datamart/src-transactions',               'table':'SRC_TRANSACTIONS',                 'env': {'EXTRACT_SRC': 'ON'}, 'origin':'ed'},
  {'uri':'datamart/src-trx-objects',                'table':'SRC_TRX_OBJECTS',                  'env': {'EXTRACT_SRC': 'ON'}, 'origin':'ed'},
  {'uri':'datamart/src-health-impacts',             'table':'SRC_HEALTH_IMPACTS',               'env': {'EXTRACT_SRC': 'ON'}, 'origin':'ed'},
  {'uri':'datamart/src-trx-health-impacts',         'table':'SRC_TRX_HEALTH_IMPACTS',           'env': {'EXTRACT_SRC': 'ON'}, 'origin':'ed'},
  {'uri':'datamart/src-violations',                 'table':'SRC_VIOLATIONS',                   'env': {'EXTRACT_SRC': 'ON'}, 'origin':'ed'},

  {'uri':'datamart/src-mod-objects',                'table':'SRC_MOD_OBJECTS',                 'env': {'EXTRACT_SRC': 'ON', 'EXTRACT_MOD': 'ON'}, 'origin':'ed'},
]