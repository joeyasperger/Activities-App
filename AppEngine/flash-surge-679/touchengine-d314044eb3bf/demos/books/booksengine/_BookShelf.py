# DO NOT EDIT. This file is machine-generated and constantly overwritten.
from google.appengine.ext import db

#import those entities we need






#modify the import below, if necessary, and uncomment
#import db.UserProperty




class _BookShelf(db.Model):


#Found attribute:comment with type:db.StringProperty

    comment = db.StringProperty()


#Found attribute:gae_id with type:db.IntegerProperty



#Found attribute:gae_key with type:db.StringProperty



#Found attribute:name with type:db.StringProperty

    name = db.StringProperty()




#Found a To Many Relationship: book_set. In app engine, these are defined in the object with the inverse relationship




#Found a To One Relationship with a to one inverse relationship: owner

#Found App engine attribute db.UserProperty
    owner = db.UserProperty()








