
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("sendFriendRequest", function(request, response){
    var sender = request.user;
    var recipient = new Parse.User();
    recipient.id = request.params.recipientID;
    recipient.relation("recievedRequests").add(sender);
    sender.relation("sentRequests").add(recipient);
    var objects = [recipient, sender];
    Parse.Cloud.useMasterKey();
    Parse.Object.saveAll(objects, {
        success: function(objs) {
            // objects have been saved...
            console.log("succeeded");
            response.success("Success!");
        },
        error: function(error) { 
            // an error occurred...
            console.log(error.message);
            response.error(error.message);
        }
    });
});

Parse.Cloud.define("friend", function(request, response){
    // Eventually need to add code to check that this is responding to 
    // a valid request
    var user1 = request.user;
    var user2 = new Parse.User();
    user2.id = request.params.friendID;
    user1.relation("friends").add(user2);
    user1.relation("sentRequests").remove(user2)
    user1.relation("recievedRequests").remove(user2)
    user2.relation("friends").add(user1);
    user2.relation("sentRequests").remove(user1)
    user2.relation("recievedRequests").remove(user1)   
    var objectsToSave = [user1, user2]
    Parse.Cloud.useMasterKey();
    Parse.Object.saveAll(objectsToSave, {
        success: function(objs) {
            // objects have been saved...
            console.log("succeeded");
            response.success("Success!");
        },
        error: function(error) { 
            // an error occurred...
            console.log(error.message);
            response.error(error.message);
        }
    });
});

Parse.Cloud.define("joinEvent", function(request, response){
    var user = request.user;
    var query = new Parse.Query("Event");

    query.get(request.params.eventID, {
        success: function(event) {
            event.increment("numberInterested");
            user.relation("eventsJoined").add(event);
            var objectsToSave = [user, event];
            Parse.Cloud.useMasterKey();
            Parse.Object.saveAll(objectsToSave, {
                success: function(objs) {
                    // objects have been saved...
                    console.log("succeeded");
                    response.success("Success!");
                },
                error: function(error) { 
                    // an error occurred...
                    console.log(error.message);
                    response.error(error.message);
                }
            });
        },
        error: function(error) {
            console.log(error.message);
            response.error(error.message);
        }
    });
});
