import db

import webapp2


class DBSetup(webapp2.RequestHandler):

    def get(self):
        # Checks for active Google account session
        self.response.headers['Content-Type'] = 'text/plain'
        self.response.write('Adding stuff to database\n')
        addTestRecords()
        self.response.write('Success')

application = webapp2.WSGIApplication([
    ('/dbsetup', DBSetup),
], debug=True)

def addTestUsers(cursor):
    addUser(cursor, 'Joey', 'Asperger')
    addUser(cursor, 'Luke', 'Asperger')
    addUser(cursor, 'Alex', 'Pinon')
    addUser(cursor, 'Jake', 'Zelek')
    addUser(cursor, 'JP', 'Olinski')
    addUser(cursor, 'Katie', 'Wardlaw')
    addUser(cursor, 'Rachel', 'Hoang')
    addUser(cursor, 'Chris', 'McWilliams')
    addUser(cursor, 'Daniel', 'Ramos')
    addUser(cursor, 'Pavan', 'Mehrotra')
    addUser(cursor, 'Kevin', 'Moody')
    addUser(cursor, 'John', 'Welsh')
    addUser(cursor, 'Julia', 'Martins')
    addUser(cursor, 'Kylie', 'Fischer')
    addUser(cursor, 'Jasmine', 'Guillory')
    addUser(cursor, 'Kaya', 'McRuer')

def addUser(cursor, firstName, lastName):
    username = firstName + ' ' + lastName
    email = firstName.lower() + lastName.lower() + '@gmail.com'
    stmt = "INSERT INTO users (email, username, firstname, lastname) VALUES (%s, %s, %s, %s);"
    params = [email, username, firstName, lastName]
    cursor.execute(stmt, params)

def addCategories(cursor, categoryList):
    for category in categoryList:
        stmt = "INSERT INTO categories (category_name) VALUES (%s);"
        params = [category]
        cursor.execute(stmt, params)

def addActivitiesForCategory(cursor, category, activities):
    cursor.execute("SELECT ID FROM categories WHERE category_name=%s", [category])
    categoryID = cursor.fetchone()[0]
    for activity in activities:
        cursor.execute("INSERT INTO activities (activity_name, category_ID) VALUES (%s, %s);",
            [activity, categoryID])

def addActivities(cursor):
    sports = ['Baseball', 'Basketball', 'Football', 'Soccer', 'Water Polo', 
        'Wiffleball', 'Softball', 'Rugby', 'Kickball', 'Ultimate Frisbee', 'Golf', 'Volleyball', 'Tennis', 'Table Tennis']
    outdoors = ['Hiking', 'Mountain Biking', 'Road Cycling', 'Whitewater Rafting', 
        'Rock Climbing', 'Surfing', 'Kayaking', 'Canoeing', 'Skiing', 'Snowboarding', 'Fishing', 'Beach']
    funAndGames = ['Laser Tag', 'Capture the Flag', 'Kart Racing', 'Minigolf', 'Paintball', 'Arcade']
    spectatorSports = ['MLB Baseball', 'NCAA Football', 'NCAA Basketball', 'NBA Basketball', 'NFL Football', 'MLS Soccer', 'NHL Hockey', 'PGA Golf', 'NASCAR Racing']
    leisure = ['Movie Theater']
    addActivitiesForCategory(cursor, 'sports', sports)
    addActivitiesForCategory(cursor, 'outdoors', outdoors)
    addActivitiesForCategory(cursor, 'Fun and Games', funAndGames)
    addActivitiesForCategory(cursor, 'Spectator Sports', spectatorSports)
    addActivitiesForCategory(cursor, 'Leisure', leisure)


def addInterests(cursor, userEmail, activities):
    userID = db.userIdFromEmail(cursor, userEmail)
    for activity in activities:
        cursor.execute("SELECT ID FROM activities WHERE activity_name=%s", [activity])
        activityID = cursor.fetchone()[0]
        cursor.execute("INSERT INTO user_activities (user_ID, activity_ID) VALUES (%s, %s);", 
            [userID, activityID])

def addTestInterests(cursor):
    addInterests(cursor, 'joeyasperger@gmail.com', ['Baseball', 'Soccer', 'Football', 'Water Polo', 'Hiking', 'Rock Climbing'])
    addInterests(cursor, 'lukeasperger@gmail.com', ['Baseball', 'Water Polo', 'Wiffleball'])
    addInterests(cursor, 'alexpinon@gmail.com', ['Soccer', 'Football', 'Rugby', 'Wiffleball'])
    addInterests(cursor, 'jpolinski@gmail.com', ['Soccer', 'Baseball', 'Hiking', 'Wiffleball'])
    addInterests(cursor, 'jakezelek@gmail.com', ['Football', 'Soccer', 'Wiffleball', 'Rugby'])

def addEvent(cursor, userEmail, eventName, activity, description):
    userID = db.userIdFromEmail(cursor, userEmail)
    cursor.execute("SELECT ID FROM activities WHERE activity_name=%s;", [activity])
    activityID = cursor.fetchone()[0]
    cursor.execute("INSERT INTO events (name, user_ID, activity_ID, description) VALUES (%s, %s, %s, %s);",
        [eventName, userID, activityID, description])


def addTestEvents(cursor):
    addEvent(cursor, "joeyasperger@gmail.com", "Wiffleball Game", "Wiffleball", "Anyone want to play some wiffleball?")
    addEvent(cursor, "lukeasperger@gmail.com", "Baseball", "Baseball", "I want to play a baseball")
    addEvent(cursor, 'alexpinon@gmail.com', 'Soccer Training', 'Soccer', 'Who wants to get some soccer training in?')
    addEvent(cursor, 'jakezelek@gmail.com', 'Football', 'Football', "Let's get a game of football going")

def addFriendsWithEmail(cursor, user1Email, user2Email):
    cursor.execute("INSERT INTO friends (user1_ID, user2_ID) VALUES (%s, %s);", 
        [db.userIdFromEmail(cursor, user1Email), db.userIdFromEmail(cursor, user2Email)])

def addTestFriends(cursor):
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "lukeasperger@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "jakezelek@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "alexpinon@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "chrismcwilliams@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "jpolinski@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "katiewardlaw@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "rachelhoang@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "danielramos@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "pavanmehrotra@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "kevinmoody@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "johnwelsh@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "juliamartins@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "kyliefischer@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "jasmineguillory@gmail.com")
    addFriendsWithEmail(cursor, "joeyasperger@gmail.com", "kayamcruer@gmail.com")


def addTestRecords():
    conn = db.get_connection()
    cursor = conn.cursor()
    addTestUsers(cursor)
    categories = ['Sports', 'Outdoors', 'Fun and Games', 'Leisure', 'Music', 'Spectator Sports', 'Live Events']
    addCategories(cursor, categories)
    addActivities(cursor)
    addTestInterests(cursor)
    addTestEvents(cursor)
    addTestFriends(cursor)
    conn.commit()
    conn.close()

