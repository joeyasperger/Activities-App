import webapp2
import db

class ShowInterests(webapp2.RequestHandler):

    def get(self):
        # Checks for active Google account session
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT ID, firstname, lastname FROM users")
        rows = cursor.fetchall()
        for i in range(cursor.rowcount):
            userID = rows[i][0]
            fullName = str(rows[i][1]) + ' ' + str(rows[i][2])
            cursor.execute("SELECT activity_name FROM activities a INNER JOIN user_activities ua ON a.ID=ua.activity_ID WHERE ua.user_ID=%s", [userID])
            self.response.write(fullName + ' likes ')
            interests = cursor.fetchall()
            for j in range(cursor.rowcount):
                self.response.write(interests[j][0] + ', ')
            self.response.write('\n')
        conn.close()

application = webapp2.WSGIApplication([
    ('/showinterests', ShowInterests),
], debug=True)