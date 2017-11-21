import os

MAPBOX_API_KEY = os.getenv('MAPBOX_API_KEY', '')
CACHE_CONFIG = {
    'CACHE_TYPE': 'redis',
    'CACHE_DEFAULT_TIMEOUT': 300,
    'CACHE_KEY_PREFIX': 'superset_',
    'CACHE_REDIS_HOST': 'redis',
    'CACHE_REDIS_PORT': 6379,
    'CACHE_REDIS_DB': 1,
    'CACHE_REDIS_URL': 'redis://redis:6379/2'}
SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2://postgres@warehouse:5432/superset'
SQLALCHEMY_TRACK_MODIFICATIONS = True
SECRET_KEY = 'v>\x0c\xba\x8d,/\xcd\r\xb7@\x9e\xf3\xd5l\xc4\xfa\xa2\x88\x9d\xf91\xe1\xe2'
