from google.appengine.api import rdbms

CLOUDSQL_INSTANCE = 'localhost'
DATABASE_NAME = 'myapp'
USER_NAME = 'joey'
PASSWORD = 'JaquenStrikeout17'

def get_connection():
    return rdbms.connect(instance=CLOUDSQL_INSTANCE, database=DATABASE_NAME,
                         user=USER_NAME, password=PASSWORD, charset='utf8')

def userIdFromEmail(cursor, email):
    cursor.execute("SELECT ID FROM users WHERE email=%s;", [email])
    return cursor.fetchone()[0]

def login(cursor, email):
    cursor.execute("SELECT ID FROM users WHERE email=%s;", [email])
    user = {}
    if cursor.rowcount != 0:
        user['id'] = cursor.fetchone()[0]
        user['email'] = email
        user['error'] = 'none'
    else:
        user['error'] = 'Invalid email address'
    return user
