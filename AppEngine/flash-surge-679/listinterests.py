import webapp2
import db
import plistlib

class ListInterests(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        userID = self.request.get('id')
        cursor.execute("SELECT a.activity_name, a.ID, a.category_ID, c.category_name FROM activities a \
            INNER JOIN user_activities ua ON ua.activity_ID=a.ID INNER JOIN categories c ON a.category_ID=c.ID WHERE ua.user_ID=%s",
            [userID])
        rows = cursor.fetchall()
        interests = []
        for i in range(cursor.rowcount):
            interest = {}
            interest['activity_name'] = str(rows[i][0])
            interest['activity_id'] = str(rows[i][1])
            interest['category_id'] = str(rows[i][2])
            interest['category_name'] = str(rows[i][3])   
            interests.append(interest)
        plist = plistlib.writePlistToString(interests)
        self.response.write(plist)
        conn.close()

application = webapp2.WSGIApplication([
    ('/listinterests', ListInterests),
], debug=True)