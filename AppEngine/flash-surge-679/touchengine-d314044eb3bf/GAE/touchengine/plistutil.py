

# Much the below modified from the gae-json-rest project
import plistlib
import logging
import re
import touchengineutil

def id_of(entity):
  """ Make a {'id': <string-of-digits>} dict for an entity.

  Args:
    entity: an entity
  Returns:
    a jobj corresponding to the entity
  """
  return dict(id=touchengineutil.id_of(entity))

def send_plist(response_obj, pdata):
  """ Send data in Plist form to an HTTP-response object.

  Args:
    response_obj: an HTTP response object
    jdata: a dict or list in correct 'plistable' form
  Side effects:
    sends the JSON form of jdata on response.out
  """
  response_obj.content_type = 'application/xml'
  #logging.info("send_plist pdata = %s" %(pdata,))
  response_obj.out.write(plistlib.writePlistToString(pdata))
  
def entity_to_dict(entity):
  """ Make a plistable dict (a dictObj) given an entity.

  Args:
    entity: an entity
  Returns:
    the JSONable-form dict (dictObj) for the entity
  """
  model = type(entity)
  dictObj = id_of(entity)
  dictObj["key"] = str(entity.key())
  props = touchengineutil.allProperties(model)
  for property_name, property_value in props:
    value_in_entity = getattr(entity, property_name, None)
    if value_in_entity is not None:
      to_string = getattr(model, property_name + '_to_string')
      #logging.info("type(value_in_entity) = %s" %(type(value_in_entity),))
      #logging.info("value_in_entity = %s" %(value_in_entity,))
      dictObj[property_name] = to_string(value_in_entity)

  
  return dictObj