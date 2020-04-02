from MySQLdb import _mysql

db = _mysql.connect(host="localhost", user="root", passwd="password", db="database")


def lambda_handler(event, context):
    return event
