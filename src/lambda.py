from MySQLdb import _mysql

db = _mysql.connect()


def lambda_handler(event, context):
    return event
