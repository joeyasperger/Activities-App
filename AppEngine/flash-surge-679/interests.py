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
            args.append(addedActivities[numberActivities-1])
            cursor.execute(statement, args)
            conn.commit()

        self.response.write('Success')
        conn.close()

class ShowInterests(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        userID = self.request.get('id')
        cursor.execute("SELECT a.activity_name, a.ID, a.category_ID, c.category_name FROM activities a \
            INNER JOIN user_activities ua ON ua.activity_ID=a.ID INNER JOIN categories c ON a.category_ID=c.ID WHERE ua.user_ID=%s \
            ORDER BY a.activity_name",
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

class DeleteInterests(webapp2.RequestHandler):

    def post(self):
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        userID = self.request.get('userID')
        deletedActivities = self.request.get_all('delete')
        for activity in deletedActivities:
            cursor.execute('DELETE FROM user_activities WHERE user_ID=%s AND activity_ID=%s;', [int(userID), int(activity)])
        conn.commit()
        self.response.write('Success')
        conn.close()


application = webapp2.WSGIApplication([
    ('/interests/add', AddInterests),('/interests/show', ShowInterests), ('/interests/delete', DeleteInterests)
], debug=True)

