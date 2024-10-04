from typing import Optional

import json
import os
import psycopg2
import psycopg2._psycopg

def lambda_handler(event, context):
    params = event.get('queryStringParameters')

    if params is None:
        return get(event, context)
    elif params.get('init') == '1':
        return init(event, context)
    elif params.get('add') == '1':
        return add(event, context)
    else:
        return get(event, context)

def get(event, context):
    db_url = os.environ['DB_URL']
    db_port = os.environ['DB_PORT']
    db_name = os.environ['DB_NAME']
    db_user = os.environ['DB_USER']
    db_password = os.environ['DB_PASS']

    query_result = None
    connection: Optional[psycopg2._psycopg.connection] = None
    try:
        connection = psycopg2.connect(f"host={db_url} port={db_port} dbname={db_name} user={db_user} password={db_password}")
        connection.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
        with connection.cursor() as cursor:
            cursor.execute("SELECT name FROM sample_table;")
            query_result = cursor.fetchall()
    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }
    finally:
        if connection:
            connection.close()

    result = [row[0] for row in query_result]
    return {
        'statusCode': 200,
        'body': json.dumps(result)
    }

def add(event, context):
    db_url = os.environ['DB_URL']
    db_port = os.environ['DB_PORT']
    db_name = os.environ['DB_NAME']
    db_user = os.environ['DB_USER']
    db_password = os.environ['DB_PASS']

    params = event.get('queryStringParameters')
    item_name = 'item_no_name'
    if params is not None and 'item_name' in params:
        item_name = params['item_name']

    connection: Optional[psycopg2._psycopg.connection] = None
    try:
        connection = psycopg2.connect(f"host={db_url} port={db_port} dbname={db_name} user={db_user} password={db_password}")
        connection.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
        
        with connection.cursor() as cursor:
            cursor.execute(f"INSERT INTO sample_table VALUES (DEFAULT, '{item_name}');")
    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }
    finally:
        if connection:
            connection.close()

    return {
        'statusCode': 200,
    }

def init(event, context):
    db_url = os.environ['DB_URL']
    db_port = os.environ['DB_PORT']
    db_name = os.environ['DB_NAME']
    db_user = os.environ['DB_USER']
    db_password = os.environ['DB_PASS']

    connection: Optional[psycopg2._psycopg.connection] = None
    try:
        connection = psycopg2.connect(f"host={db_url} port={db_port} dbname={db_name} user={db_user} password={db_password}")
        connection.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
        
        with connection.cursor() as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS sample_table (id SERIAL PRIMARY KEY, name VARCHAR(255));")
    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }
    finally:
        if connection:
            connection.close()

    return {
        'statusCode': 200,
    }
