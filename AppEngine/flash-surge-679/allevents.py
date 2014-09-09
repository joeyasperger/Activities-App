import webapp2
import db
import plistlib

class AllEvents(webapp2.RequestHandler):

    def get(self):
        # Checks for active Google account session
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT u.username, u.ID, a.activity_name, e.name, e.ID, e.description, e.number_interested FROM events e INNER JOIN activities a ON a.ID=e.activity_ID INNER JOIN users u ON e.user_ID=u.ID;")
        rows = cursor.fetchall()
        events = []
        for i in range(cursor.rowcount):
            event = {}
            event['username'] = str(rows[i][0])
            event['userID'] = str(rows[i][1])
            event['activity'] = str(rows[i][2])
            event['eventName'] = str(rows[i][3])
            event['ID'] = str(rows[i][4])
            event['description'] = str(rows[i][5])
            event['numberInterested'] = str(rows[i][6])
            events.append(event)
        plist = plistlib.writePlistToString(events)
        self.response.write(plist)
        conn.close()

application = webapp2.WSGIApplication([
    ('/allevents', AllEvents),
], debug=True)