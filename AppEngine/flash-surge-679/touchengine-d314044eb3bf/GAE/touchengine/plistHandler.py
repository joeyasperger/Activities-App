#!/usr/bin/env python

import logging
import time
import re

import wsgiref.handlers
from google.appengine.ext import webapp
from google.appengine.ext.db import Key

import cookutil
import touchengineutil
import plistutil

# RE to match: optional /, classname, optional /, ID of 0+ numeric digits
CLASSNAME_ID_RE = re.compile(r'^/?(\w+)/?(\d*)$')

# TODO: queries, methods, schemas, and MUCH better error-handling!-)

def path_to_classname_and_id(path):
  """ Get a (classname, id) pair from a path.

  Args:
    path: a path string to anaylyze
  Returns:
    a 2-item tuple:
      (None, '')            if the path does not match CLASSNAME_ID_RE
      (classname, idstring) if the path does match
                            [idstring may be '', or else a string of digits]
  """
  mo = CLASSNAME_ID_RE.match(path)
  if mo: return mo.groups()
  else: return (None, '')
  

class PlistHandler(webapp.RequestHandler, cookutil.CookieMixin):
  stripFromURL = ''
  def _serve(self, data):
    counter = self.get_cookie('counter')
    if counter: self.set_cookie('counter', str(int(counter) + 1))
    else: self.set_cookie('counter', '0')
    return plistutil.send_plist(self.response, data)

  def _get_model_and_entity(self, need_model, need_id):
    """ Analyze self.request.path to get model and entity.

    Args:
      need_model: bool: if True, fail if classname is missing
      need_id: bool: if True, fail if ID is missing

    Returns 3-item tuple:
      failed: bool: True iff has failed
      model: class object or None
      entity: instance of model or None
    """
    path = self.request.path.lstrip(self.stripFromURL)
    logging.info(u'path = %s (stripFromURL = %s)' %(path, self.stripFromURL))
    classname, strid = path_to_classname_and_id(path)
    self._classname = classname
    if not classname:
      if need_model:
        self.response.set_status(400, 'Cannot do it without a model.')
        logging.info(u'_get_model_and_entity 400, Cannot do it without a model.')
      return need_model, None, None
    model = touchengineutil.modelClassFromName(classname)
    if model is None:
      self.response.set_status(400, 'Model %r not found' % classname)
      logging.info(u'_get_model_and_entity 400, Model %r not found' % classname)
      return True, None, None
    if not strid:
      if need_id:
        self.response.set_status(400, 'Cannot do it without an ID.')
        logging.info(u'_get_model_and_entity 400, Cannot do it without an ID.')
      return need_id, model, None
    try:
      numid = int(strid)
    except TypeError:
      self.response.set_status(400, 'ID %r is not numeric.' % strid)
      logging.info(u'_get_model_and_entity 400, ID %r is not numeric.' % strid)
      return True, model, None
    else:
      entity = model.get_by_id(numid)
      if entity is None:
        self.response.set_status(404, "Entity %s not found" % self.request.path)
        logging.info(u'_get_model_and_entity 400, Entity %s not found' % self.request.path)
        return True, model, None
    logging.info(u'_get_model_and_entity model:%s entity:%s', model, entity)
    return False, model, entity
 
 
  def _get(self, short=True, limit=None, afterKey=None, orderBy=None):
    """ Get Plist data for model names, entity IDs of a model, or an entity.

    Depending on the request path, serve as JSON to the response object:
    - for a path of /classname/id, a plist for that entity
    - for a path of /classname, a list of id-only strings for that model
      or a list of all entities (if short is False)
    - for a path of /, a list of all model class names, which allows the API
      to be introspected
      
    this needs some sanitization to keep from throwing exceptions all over
    the place when the user sends a string that makes us puke.
    """
    coon = str(1 + int(self.get_cookie('coon', '0')))
    self.set_cookie('count', coon)
    self.set_cookie('ts', str(int(time.time())))
    failed, model, entity = self._get_model_and_entity(False, False)
    dictObj = {}
    if failed: 
      #todo: put the errors above in here as well
      dictObj = {"error":"See response code"} 
      
    elif model is None:
      #return all class names
      dictObj = {"allModelClassNames":touchengineutil.allModelClassNames()}
      
    #TODO: yeah, all these nested "if" statements, ugly.  
    elif entity is None:
      classSetname = model.__name__ + "_set"
      if not limit:
        if not afterKey:
          if not orderBy:
            models = model.all()
          else:
            models = model.gql("order by %s" %(orderBy,)) #todo: sanitize me? check Model.properties() for orderBy at least
        else:
          if not orderBy:
            models = model.gql("Where __key__ > :1", Key(encoded=afterKey)) #todo: handle key doesn't exist
          else:
            models = model.gql("Where __key__ > :1 order by %s" %(orderBy,), Key(encoded=afterKey))
      else: #limit
        if not afterKey:
          if not orderBy:
            models = model.all().fetch(int(limit))
          else:
            models = model.gql("order by %s" %(orderBy, )).fetch(int(limit))
        else:  
          if not orderBy:
            models = model.gql("Where __key__ > :1", Key(encoded=afterKey)).fetch(int(limit))
          else:
            models = model.gql("Where __key__ > :1 order by %s" %(orderBy,), Key(encoded=afterKey)).fetch(int(limit))
          
      if short:
        dictObj = {classSetname:[touchengineutil.classAndIdFromModelInstance(eachModelInstance) for eachModelInstance in models]}
      else:
        dictObj = {classSetname:[plistutil.entity_to_dict(eachModelInstance) for eachModelInstance in models]}
      
    else:  
      #return the dictionary representation of the entity in question
      dictObj = plistutil.entity_to_dict(entity)
    return self._serve(dictObj)
    
  def get(self):
    limit = self.request.get("limit")
    afterKey = self.request.get("afterKey")
    short = self.request.get("short")
    orderBy = self.request.get("orderBy")
    #logging.info("orderBy = %s" %(orderBy,))
    if short: short=True #anything in short makes it true
    else: short=False
    return self._get(short=short, limit=limit, afterKey=afterKey, orderBy=orderBy)