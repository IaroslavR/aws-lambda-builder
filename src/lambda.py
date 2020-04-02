from time import sleep

from MySQLdb import _mysql

sleep(5)  # wait for server
db = _mysql.connect(host="mysql", user="root", passwd="password", db="database")


def lambda_handler(event, context):
    return event
