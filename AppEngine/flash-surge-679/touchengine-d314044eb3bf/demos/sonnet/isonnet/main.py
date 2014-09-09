#!/usr/bin/env python
#Python sonnet maker

import wsgiref.handlers
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

#external imports
import sonnet
import plistlib

class MainHandler(webapp.RequestHandler):
    """Returns sonnets dictionary as a converted plist"""
    def get(self):
        plist = plistlib.writePlistToString(sonnet.verses)
        self.response.out.write(plist)

class FrontPage(webapp.RequestHandler):
    """Displays front page"""
    def get(self):
        self.response.out.write("""
        <html>
        <title>iSonnet Application</title>
        <body>
        <p>This is a simple web service.</p>
        <p>
        A plist is served out here:
        <a href="http://isonnet.appspot.com/plists/sonnets">isonnet</a>
        </p>
        <p>
        The Touch Engine Open Source Project is here:
        <a href="http://code.google.com/p/touchengine/">touchengine</a>
        </p>
        </body>
        </html>
        """)
def main():
    application = webapp.WSGIApplication([('/plists/sonnets', MainHandler),
                                            ('/', FrontPage),
                                        ],
                                        debug=True)
    run_wsgi_app(application)


if __name__ == '__main__':
  main()
