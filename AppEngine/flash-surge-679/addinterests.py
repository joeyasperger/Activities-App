import webapp2
import db
import plistlib

class AddInterests(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        userID = self.request.get('id')
        addedActivities = self.request.get_all('add')
        print addedActivities
        self.response.write('Success')
        conn.close()

application = webapp2.WSGIApplication([
    ('/addinterests', AddInterests),
], debug=True)