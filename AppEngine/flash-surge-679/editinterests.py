import webapp2
import db
import plistlib

class EditInterests(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        userID = self.request.get('id')
        addedActivities = self.request.get_all('add')
        deletedActivities = self.request.get_all('delete')
        print addedActivities
        print deletedActivities
        self.response.write('Success')
        conn.close()

application = webapp2.WSGIApplication([
    ('/editinterests', EditInterests),
], debug=True)