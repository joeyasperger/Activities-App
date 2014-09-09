import webapp2
import db

class Something(webapp2.RequestHandler):

    def get(self):
        # Checks for active Google account session
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT firstname, lastname FROM users;")
        rows = cursor.fetchall()
        for i in range(cursor.rowcount):
        	self.response.write(str(rows[i][0]) + ' ' + str(rows[i][1]) + '\n')
        conn.close()

application = webapp2.WSGIApplication([
    ('/users', Something),
], debug=True)