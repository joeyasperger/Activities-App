#!/usr/bin/env python

import wsgiref.handlers

from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext import db
from google.appengine.ext.webapp import template

from django.utils import simplejson

from touchengine.plistHandler import PlistHandler
from models import *

from dateutil import parser
import datetime 

import logging
import os

class MainPage(webapp.RequestHandler):
    """Main Page View"""

    def get(self):
        user = users.get_current_user()

        if user:
            url = users.create_logout_url(self.request.uri)
            url_linktext = 'Logout'
        else:
            url = None
            url_linktext = None
            self.redirect(users.create_login_url(self.request.uri))
            
        template_values = {
        'url': url,
        'url_linktext': url_linktext,
        'username': users.get_current_user(),
        }
        path = os.path.join(os.path.dirname(__file__), 'base.html')
        self.response.out.write(template.render(path, template_values))


class MainPageLibrary(webapp.RequestHandler):
    """Main Page View With Library Grid"""

    def get(self):
        user = users.get_current_user()

        if users.get_current_user():
            url = users.create_logout_url(self.request.uri)
            url_linktext = 'Logout'
        else:
            url = None
            url_linktext = None
            self.redirect(users.create_login_url(self.request.uri))
            
        template_values = {
        'url': url,
        'url_linktext': url_linktext,
        'username': users.get_current_user(),
        }
        path = os.path.join(os.path.dirname(__file__), 'library.html')
        self.response.out.write(template.render(path, template_values))

class Recent(webapp.RequestHandler):
    """Query Last 10 Requests"""

    def get(self):

        #collection
        collection = []
        #grab last 10 records from datastore
        query = Book.all().order('-date')
        records = query.fetch(limit=10)
        logging.info(collection)
        for book_record in records:
            collection.append(book_record.title)

        self.response.out.write(collection)

class Library(webapp.RequestHandler):
    """Returns Library Contents"""
    
    def get(self):
        #Just grab the latest post
        aaData = dict(aaData=[])

        #select the latest input from the datastore
        record = db.GqlQuery("""
                SELECT * FROM Book ORDER BY date DESC LIMIT 100""")
        for book in record:
            row = []
            row.append(book.title)
            row.append(book.author)
            row.append(book.copyright.strftime('%Y'))
            aaData['aaData'].append(row)
            logging.info('book = %s' %(book,))
            
        aaData = simplejson.dumps(aaData)
        logging.info("GET: %s" % aaData)
        self.response.headers['Content-Type'] = 'application/json'
        self.response.out.write(aaData)
        
class CreateBook(webapp.RequestHandler):

    def userBookshelf(self):
        """Gets the users bookshelf if none, makes one"""
        user = users.get_current_user()
        bookshelf = None
        #only make a shelf if the user is not an admin
        if user and not users.is_current_user_admin():
            bookshelvesQuery = BookShelf.all().filter('owner = ', user)
            bookshelf = bookshelvesQuery.get()
            if not bookshelf:
                bookshelf = BookShelf(owner=user)
                bookshelf.put()
        logging.info(u'shelf = %s' %(bookshelf,))
        return bookshelf

    def post(self):
        """Stores a new book entry"""
        
        title = self.request.get('title')
        author = self.request.get('author')
        copyright = self.request.get('copyright')

        #Create new book and save it
        book = Book()
        book.title = title
        book.author = author
        copyrightDate = parser.parse(copyright)
        book.copyright = copyrightDate
        book.date = datetime.datetime.now()
        
        #automatically add to current user's shelf
        shelf = self.userBookshelf()
        if shelf:
            book.bookshelf = shelf
        book.put()
        
        logging.info((title, author, copyright))
        self.response.out.write("""
        Book Updated: Title: %s, Author: %s, Copyright: %s""" %\
            (book.title, book.author, book.copyright))

class CustomPlistHandler(PlistHandler):
    stripFromURL = '/plist/'

def main():
    application = webapp.WSGIApplication([('/', MainPage),
                                        ('/alt', MainPageLibrary),
                                        ('/submit_form', CreateBook),
                                        ('/library', Library),
                                        ('/plist/.*', CustomPlistHandler),
                                        ],debug=True)
    wsgiref.handlers.CGIHandler().run(application)

if __name__ == "__main__":
    main()
