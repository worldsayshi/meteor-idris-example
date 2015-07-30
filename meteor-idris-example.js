var idris_string = new ReactiveVar("no string yet");
var idris_string2 = new ReactiveVar("base string");

if (Meteor.isClient) {
    Template.idrisTest.helpers({
        someData: function () {
            return idris_string.get();
        },
        someData2: function () {
            return idris_string2.get();
        }
    });
    Template.idrisTest.onCreated(function () {
        var instance = this;
        Meteor.call("idris_string",function (err, res) {
            idris_string.set(res);
        });
        Meteor.call("idris_fn", [idris_string2.get()],function (err, res) {
            idris_string2.set(res);
        });

    });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
