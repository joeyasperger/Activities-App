
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("sendFriendRequest", function(request, response){
    var sender = request.user;
    var recipient = new Parse.User();
    recipient.id = request.params.recipientID;
    recipient.relation("requestFrom").add(sender);
    sender.relation("requestTo").add(recipient);
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

});
