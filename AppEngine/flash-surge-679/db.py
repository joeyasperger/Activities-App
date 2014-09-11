from google.appengine.api import rdbms

CLOUDSQL_INSTANCE = 'localhost'
DATABASE_NAME = 'myapp'
USER_NAME = 'joey'
PASSWORD = 'JaquenStrikeout17'

# CLOUDSQL_INSTANCE = 'flash-surge-679:dev-instance-0'
# DATABASE_NAME = 'spring'
# USER_NAME = 'root'
# PASSWORD = 'DodgersXKCD17'

def get_connection():
    return rdbms.connect(instance=CLOUDSQL_INSTANCE, database=DATABASE_NAME,
                         user=USER_NAME, password=PASSWORD, charset='utf8')

def userIdFromEmail(cursor, email):
    cursor.execute("SELECT ID FROM users WHERE email=%s;", [email])
    return cursor.fetchone()[0]

def login(cursor, email):
    cursor.execute("SELECT ID, username FROM users WHERE email=%s;", [email])
    user = {}
    if cursor.rowcount != 0:
        row = cursor.fetchone()
        user['id'] = row[0]
        user['username'] = row[1]
        user['email'] = email
        user['error'] = 'none'
    else:
        user['error'] = 'Invalid email address'
    return user
