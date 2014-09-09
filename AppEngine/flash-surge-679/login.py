import webapp2
import db
import plistlib

class Login(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        email = self.request.get('email')
        user = db.login(cursor, email)
        plist = plistlib.writePlistToString(user)
        self.response.write(plist)
        conn.close()

application = webapp2.WSGIApplication([
    ('/login', Login),
], debug=True)