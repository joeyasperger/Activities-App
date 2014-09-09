"""A toy-level example of a RESTful app running on Google Appengine.
"""
import logging
import time

import wsgiref.handlers
from google.appengine.ext import webapp
import models
from touchengine import cookutil
from touchengine import touchengineutil
from touchengine import plistutil
from touchengine.plistHandler import PlistHandler
# TODO: queries, methods, schemas, and MUCH better error-handling!-)

def main():
  logging.info('main.py main()')
  application = webapp.WSGIApplication([('/.*', PlistHandler)],
      debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
