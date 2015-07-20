if (Meteor.isClient) {
  Template.idrisTest.helpers({
    someData: function () {
        return someData;
    }
  });

  Template.idrisTest.events({
    'click button': function () {
      // increment the counter when button is clicked
      Session.set('counter', Session.get('counter') + 1);
    }
  });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}

printIt = function (obj) {
    console.log(obj);
};
