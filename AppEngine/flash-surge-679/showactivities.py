import webapp2
import db
import plistlib

class ShowActivities(webapp2.RequestHandler):

    def get(self):
        # Checks for active Google account session
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT a.activity_name, c.category_name FROM activities a INNER JOIN categories c ON a.category_ID=c.ID;")
        rows = cursor.fetchall()
        # categories = []
        # for i in range(cursor.rowcount):
        #     # plist stuff
        #     category = str(rows[i][1])
        #     activity = str(rows[i][0])
        #     if category not in categories:
        #         categories.append(category)
        categories = {}
        for i in range(cursor.rowcount):
            # plist stuff
            category = str(rows[i][1])
            activity = str(rows[i][0])
            if category not in categories.keys():
                categories[category] = []
            categories[category].append(activity)
        plist = plistlib.writePlistToString(categories)
        self.response.write(plist)
        conn.close()

application = webapp2.WSGIApplication([
    ('/showactivities', ShowActivities),
], debug=True)