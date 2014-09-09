# DO NOT EDIT. This file is machine-generated and constantly overwritten.
from google.appengine.ext import db

#import those entities we need



from BookShelf import BookShelf




class _Book(db.Model):


#Found attribute:author with type:db.StringProperty

    author = db.StringProperty()


#Found attribute:copyright with type:db.DateTimeProperty

    copyright = db.DateTimeProperty()


#Found attribute:date with type:db.DateTimeProperty

    date = db.DateTimeProperty()


#Found attribute:gae_id with type:db.IntegerProperty



#Found attribute:gae_key with type:db.StringProperty



#Found attribute:title with type:db.StringProperty

    title = db.StringProperty()





#Found a To One Relationship with a to many inverse relationship: bookshelf

    bookshelf = db.ReferenceProperty(BookShelf, collection_name='book_set')








