
import webapp2


class Default(webapp2.RequestHandler):

    def get(self):
        # Checks for active Google account session
        self.response.headers['Content-Type'] = 'text/plain'
        self.response.write('This is the server for my app')

application = webapp2.WSGIApplication([
    ('/', Default),
], debug=True)