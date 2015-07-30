var idris_string = new ReactiveVar("no string yet");

if (Meteor.isClient) {
    Template.idrisTest.helpers({
        someData: function () {
            return idris_string.get();
        }
    });
    Template.idrisTest.onCreated(function () {
        var instance = this;
        Meteor.call("idris_string",function (err, res) {
            idris_string.set(res);
        });
    });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
