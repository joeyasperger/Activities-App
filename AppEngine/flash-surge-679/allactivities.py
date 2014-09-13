import webapp2
import db
import plistlib

class AllActivities(webapp2.RequestHandler):

    def get(self):
        # Checks for active Google account session
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT a.activity_name, a.ID, a.category_ID, c.category_name FROM activities a \
            INNER JOIN categories c on a.category_ID=c.ID ORDER BY c.category_name, a.activity_name;")
        rows = cursor.fetchall()
        activities = []
        for i in range(cursor.rowcount):
            activity = {}
            activity['activity_name'] = str(rows[i][0])
            activity['activity_id'] = str(rows[i][1])
            activity['category_id'] = str(rows[i][2])
            activity['category_name'] = str(rows[i][3])
            activities.append(activity)
        plist = plistlib.writePlistToString(activities)
        self.response.write(plist)
        conn.close()

application = webapp2.WSGIApplication([
    ('/allactivities', AllActivities),
], debug=True)