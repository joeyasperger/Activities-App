import webapp2
import db
import plistlib

class AddInterests(webapp2.RequestHandler):

    def post(self):
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        userID = self.request.get('userID')
        addedActivities = self.request.get_all('add')
        numberActivities = len(addedActivities)
        if (numberActivities > 0):
            statement = "INSERT INTO user_activities (user_ID, activity_ID) VALUES "
            args = []
            for i in range(numberActivities-1):
                statement += "(%s, %s), "
                args.append(int(userID))
                args.append(addedActivities[i])
            statement += "(%s, %s);"
            args.append(int(userID))
            args.append(numberActivities-1)
            cursor.execute(statement, args)
            conn.commit()

        self.response.write('Success')
        conn.close()

application = webapp2.WSGIApplication([
    ('/addinterests', AddInterests),
], debug=True)