"""A toy-level example of a data model in Google Appengine DB terms.
"""
import logging
from touchengine import touchengineutil

from Doctor import Doctor
from Pager import Pager

touchengineutil.decorateModuleNamed(__name__)
logging.info('touchengine Models in %r decorated', __name__)
