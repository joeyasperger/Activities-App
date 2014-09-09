import webapp2
import db
import plistlib

class ListFriends(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'text/plain'
        conn = db.get_connection()
        cursor = conn.cursor()
        userID = self.request.get('id')
        if userID == '':
            email = self.request.get('email')
            userID = db.userIdFromEmail(cursor, email)
        cursor.execute("SELECT u.username, u.ID FROM users u INNER JOIN friends f ON u.ID=f.user1_ID WHERE f.user2_ID=%s UNION SELECT u.username, u.ID FROM users u INNER JOIN friends f ON u.ID=f.user2_ID WHERE f.user1_ID=%s;",
            [userID, userID])
        rows = cursor.fetchall()
        friends = []
        for i in range(cursor.rowcount):
            friend = {}
            friend['username'] = str(rows[i][0])
            friend['userID'] = str(rows[i][1])
            friends.append(friend)
        plist = plistlib.writePlistToString(friends)
        self.response.write(plist)
        conn.close()

application = webapp2.WSGIApplication([
    ('/listfriends', ListFriends),
], debug=True)