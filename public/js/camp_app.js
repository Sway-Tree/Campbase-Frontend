// Generated by CoffeeScript 1.6.3
(function() {
  var App, Glue, Gui, Server, UseCase, app,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _.defaults(this, {
    Before: function(object, methodName, adviseMethod) {
      return YouAreDaBomb(object, methodName).before(adviseMethod);
    },
    BeforeAnyCallback: function(object, methodName, adviseMethod) {
      return YouAreDaBomb(object, methodName).beforeAnyCallback(adviseMethod);
    },
    After: function(object, methodName, adviseMethod) {
      return YouAreDaBomb(object, methodName).after(adviseMethod);
    },
    Around: function(object, methodName, adviseMethod) {
      return YouAreDaBomb(object, methodName).around(adviseMethod);
    }
  });

  Server = (function() {
    function Server() {
      this.reloadMainFeed = __bind(this.reloadMainFeed, this);
      this.participantsTaken = __bind(this.participantsTaken, this);
      this.tripsTaken = __bind(this.tripsTaken, this);
      this.userTaken = __bind(this.userTaken, this);
      this.take_participants = __bind(this.take_participants, this);
    }

    Server.prototype.take_user = function(trips) {
      var _this = this;
      return $.ajax({
        url: "http://0.0.0.0:3000/user.json",
        type: "GET",
        success: function(user) {
          console.log("success");
          return _this.userTaken(user, trips);
        },
        error: function(e) {
          console.log(e);
          return console.log("fail");
        },
        xhrFields: {
          withCredentials: true
        },
        crossDomain: true
      });
    };

    Server.prototype.login_user = function(data) {
      var _this = this;
      return $.ajax({
        url: "http://0.0.0.0:3000/users/sign_in.json",
        type: "POST",
        data: {
          email: data[0],
          password: data[1]
        },
        success: function(user) {
          console.log("success");
          return _this.reloadMainFeed();
        },
        error: function(e) {
          console.log(e);
          return console.log("fail");
        },
        xhrFields: {
          withCredentials: true
        },
        crossDomain: true
      });
    };

    Server.prototype.take_trips = function() {
      var _this = this;
      return $.ajax({
        url: "http://0.0.0.0:3000/trips.json",
        type: "GET",
        success: function(trips) {
          console.log("success");
          return _this.tripsTaken(trips);
        },
        error: function() {
          return console.log("fail");
        }
      });
    };

    Server.prototype.save_trip = function(info) {
      var _this = this;
      return $.ajax({
        url: "http://0.0.0.0:3000/trips.json",
        type: "POST",
        data: {
          name: info[0],
          place: info[1],
          from: info[2],
          to: info[3],
          price: info[4],
          photo: info[5],
          description: info[6]
        },
        success: function(data, status, response) {
          console.log("success");
          return _this.reloadMainFeed();
        },
        error: function() {
          return console.log("fail");
        },
        dataType: "json"
      });
    };

    Server.prototype.update_trip = function(id, info) {
      var _this = this;
      return $.ajax({
        url: "http://0.0.0.0:3000/trips/" + id + ".json",
        type: "PUT",
        data: {
          name: info[0],
          place: info[1],
          from: info[2],
          to: info[3],
          price: info[4],
          photo: info[5],
          description: info[6]
        },
        success: function(data, status, response) {
          console.log("success");
          return _this.reloadMainFeed();
        },
        error: function() {
          return console.log("fail");
        },
        dataType: "json"
      });
    };

    Server.prototype.delete_trip = function(id) {
      var _this = this;
      return $.ajax({
        url: "http://0.0.0.0:3000/trips/" + id + ".json",
        type: "DELETE",
        success: function(data, status, response) {
          console.log("success");
          return _this.reloadMainFeed();
        },
        error: function() {
          return console.log("fail");
        },
        dataType: "json"
      });
    };

    Server.prototype.join_the_trip = function(id) {
      var _this = this;
      return $.ajax({
        url: "http://0.0.0.0:3000/trips/" + id + "/enroll.json",
        type: "GET",
        success: function(data, status, response) {
          console.log("success");
          return _this.reloadMainFeed();
        },
        error: function() {
          return console.log("fail");
        },
        xhrFields: {
          withCredentials: true
        },
        crossDomain: true
      }, {
        dataType: "json"
      });
    };

    Server.prototype.take_participants = function(id) {
      var _this = this;
      return $.ajax({
        url: "http://0.0.0.0:3000/trips/" + id + "/participants.json",
        type: "GET",
        success: function(data, status, response) {
          console.log(data);
          return _this.participantsTaken(data);
        },
        error: function() {
          return console.log("fail");
        },
        xhrFields: {
          withCredentials: true
        },
        crossDomain: true
      }, {
        dataType: "json"
      });
    };

    Server.prototype.userTaken = function(user, trips) {};

    Server.prototype.tripsTaken = function(trips) {};

    Server.prototype.participantsTaken = function() {};

    Server.prototype.reloadMainFeed = function() {};

    return Server;

  })();

  UseCase = (function() {
    function UseCase(server) {
      this.server = server;
      this.getParticipants = __bind(this.getParticipants, this);
      this.joinTheTrip = __bind(this.joinTheTrip, this);
      this.deleteTripOnBackend = __bind(this.deleteTripOnBackend, this);
      this.updateTripOnBackend = __bind(this.updateTripOnBackend, this);
      this.sendTripOnBackend = __bind(this.sendTripOnBackend, this);
      this.addTripButton = __bind(this.addTripButton, this);
      this.showTrips = __bind(this.showTrips, this);
      this.loadTrips = __bind(this.loadTrips, this);
      this.loadUser = __bind(this.loadUser, this);
      this.loadInitial = __bind(this.loadInitial, this);
      this.logInUser = __bind(this.logInUser, this);
      this.showLogIn = __bind(this.showLogIn, this);
      this.showProfile = __bind(this.showProfile, this);
      this.editAndDelete = __bind(this.editAndDelete, this);
      this.showUsersInfo = __bind(this.showUsersInfo, this);
    }

    UseCase.prototype.start = function() {
      console.log("hello");
      return this.loadInitial();
    };

    UseCase.prototype.showUsersInfo = function(User, Trips) {
      console.log(User);
      if (User != null) {
        this.showProfile(User);
        if (User.admin === true) {
          this.editAndDelete(Trips);
          return this.addTripButton();
        }
      } else {
        return this.showLogIn();
      }
    };

    UseCase.prototype.editAndDelete = function(Trips) {};

    UseCase.prototype.showProfile = function(user) {};

    UseCase.prototype.showLogIn = function() {};

    UseCase.prototype.logInUser = function(data) {
      return this.server.login_user(data);
    };

    UseCase.prototype.loadInitial = function() {
      return this.loadTrips();
    };

    UseCase.prototype.loadUser = function(trips) {
      return this.server.take_user(trips);
    };

    UseCase.prototype.loadTrips = function() {
      return this.server.take_trips();
    };

    UseCase.prototype.showTrips = function(Trips) {};

    UseCase.prototype.addTripButton = function() {};

    UseCase.prototype.sendTripOnBackend = function(info) {
      return this.server.save_trip(info);
    };

    UseCase.prototype.updateTripOnBackend = function(id, info) {
      return this.server.update_trip(id, info);
    };

    UseCase.prototype.deleteTripOnBackend = function(id) {
      return this.server.delete_trip(id);
    };

    UseCase.prototype.joinTheTrip = function(id) {
      return this.server.join_the_trip(id);
    };

    UseCase.prototype.getParticipants = function(id) {
      return this.server.take_participants(id);
    };

    return UseCase;

  })();

  Gui = (function() {
    function Gui() {
      this.tripsLoaded = __bind(this.tripsLoaded, this);
      this.feedEmptied = __bind(this.feedEmptied, this);
      this.participantsTrip = __bind(this.participantsTrip, this);
      this.deleteTrip = __bind(this.deleteTrip, this);
      this.updateTrip = __bind(this.updateTrip, this);
      this.saveNewTrip = __bind(this.saveNewTrip, this);
      this.showParticipants = __bind(this.showParticipants, this);
      this.refreshTrips = __bind(this.refreshTrips, this);
      this.addingTrips = __bind(this.addingTrips, this);
      this.editTripForm = __bind(this.editTripForm, this);
      this.enrollForTrip = __bind(this.enrollForTrip, this);
      this.tripDetailsClicked = __bind(this.tripDetailsClicked, this);
      this.showOptions = __bind(this.showOptions, this);
      this.showEditAndDelete = __bind(this.showEditAndDelete, this);
      this.showTrip = __bind(this.showTrip, this);
      this.tripsOnFeed = __bind(this.tripsOnFeed, this);
      this.editProfileClicked = __bind(this.editProfileClicked, this);
      this.signUpClicked = __bind(this.signUpClicked, this);
      this.logInClicked = __bind(this.logInClicked, this);
      this.logInForm = __bind(this.logInForm, this);
      this.fillThePanel = __bind(this.fillThePanel, this);
      this._createElementFor = __bind(this._createElementFor, this);
    }

    Gui.prototype._createElementFor = function(templateId, data) {
      var element, html, source, template;
      source = $(templateId).html();
      template = Handlebars.compile(source);
      html = template(data);
      return element = $(html);
    };

    Gui.prototype.fillThePanel = function(user) {
      var element,
        _this = this;
      element = this._createElementFor("#profile-template", {
        photo: user.photo,
        name: user.name,
        surname: user.surname
      });
      $("#userPanel").html(element);
      return $("#edit-profile-button").click(function() {
        return _this.editProfileClicked(user);
      });
    };

    Gui.prototype.logInForm = function() {
      var element,
        _this = this;
      element = this._createElementFor("#log-in-form-template");
      $("#userPanel").html(element);
      $("#log-in-button").click(function() {
        return _this.logInClicked([$("#user-email").val, $("#user-password").val]);
      });
      return $("#sign-up-button").click(function() {
        return _this.signUpClicked();
      });
    };

    Gui.prototype.logInClicked = function(data) {};

    Gui.prototype.signUpClicked = function() {
      var element;
      $("#userPanel").empty();
      element = this._createElementFor("#create-profile-template");
      return $("#userPanel").html(element);
    };

    Gui.prototype.editProfileClicked = function(user) {
      var element;
      $("#userPanel").empty();
      element = this._createElementFor("#edit-profile-template", {
        photo: user.photo,
        name: user.name,
        surname: user.surname,
        email: user.email
      });
      return $("#userPanel").html(element);
    };

    Gui.prototype.tripsOnFeed = function(Trips) {
      var trip, _i, _len;
      for (_i = 0, _len = Trips.length; _i < _len; _i++) {
        trip = Trips[_i];
        this.showTrip(trip);
      }
      return this.tripsLoaded(Trips);
    };

    Gui.prototype.showTrip = function(trip) {
      var detailRequest, element,
        _this = this;
      element = this._createElementFor("#trip-row-template", {
        photo: trip.photo,
        name: trip.name,
        place: trip.place,
        id: trip.id
      });
      $("#mainFeed").append(element);
      detailRequest = $("#show-trip-details" + trip.id);
      return detailRequest.click(function() {
        return _this.tripDetailsClicked(trip.description, trip.id);
      });
    };

    Gui.prototype.showEditAndDelete = function(Trips) {
      var trip, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = Trips.length; _i < _len; _i++) {
        trip = Trips[_i];
        _results.push(this.showOptions(trip));
      }
      return _results;
    };

    Gui.prototype.showOptions = function(trip) {
      var deleteRequest, editRequest, element, participantsRequest,
        _this = this;
      element = this._createElementFor("#edit-delete-template", {
        id: trip.id
      });
      $("#trip-" + trip.id).append(element);
      editRequest = $("#edit-trip" + trip.id);
      editRequest.click(function() {
        return _this.editTripForm(trip);
      });
      deleteRequest = $("#delete-trip" + trip.id);
      deleteRequest.click(function() {
        return _this.deleteTrip(trip.id);
      });
      participantsRequest = $("#participants-trip" + trip.id);
      return participantsRequest.click(function() {
        return _this.participantsTrip(trip.id);
      });
    };

    Gui.prototype.tripDetailsClicked = function(description, i) {
      var element, signUp,
        _this = this;
      element = this._createElementFor("#show-trip-details-template", {
        description: description,
        id: i
      });
      $("#myModal").html(element);
      $('#myModal').foundation('reveal', 'open');
      signUp = $("#going-on-trip");
      signUp.click(function() {
        return _this.enrollForTrip(i);
      });
      return $('#myModal').foundation('reveal', 'close');
    };

    Gui.prototype.enrollForTrip = function(i) {};

    Gui.prototype.editTripForm = function(trip) {
      var editButton, element,
        _this = this;
      element = this._createElementFor("#edit-trip-template", {
        name: trip.name,
        place: trip.place,
        from: trip.from,
        to: trip.to,
        price: trip.price,
        photo: trip.photo,
        description: trip.description
      });
      $("#editModal").html(element);
      $('#editModal').foundation('reveal', 'open');
      editButton = $("#editTripButton");
      editButton.click(function() {
        return _this.updateTrip(trip.id, [$("#tripName").val(), $("#tripPlace").val(), $("#tripFrom").val(), $("#tripTo").val(), $("#tripPrice").val(), $("#tripPhoto").val(), $("#tripDesc").val()]);
      });
      return $('#editModal').foundation('reveal', 'close');
    };

    Gui.prototype.addingTrips = function() {
      var element, saveButton,
        _this = this;
      element = this._createElementFor("#add-new-trip-template");
      $("#addField").append(element);
      $("#addNewTrip").click(function() {
        return $('#addModal').foundation('reveal', 'open');
      });
      saveButton = $("#saveTripButton");
      return saveButton.click(function() {
        return _this.saveNewTrip([$("#tripName").val(), $("#tripPlace").val(), $("#tripFrom").val(), $("#tripTo").val(), $("#tripPrice").val(), $("#tripPhoto").val(), $("#tripDesc").val()]);
      });
    };

    Gui.prototype.refreshTrips = function() {
      $("#mainFeed").empty();
      $("#addField").empty();
      return this.feedEmptied();
    };

    Gui.prototype.showParticipants = function(data) {
      var element, i, user, _i, _len;
      i = 1;
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        user = data[_i];
        element = this._createElementFor("#participant-template", {
          name: user.name,
          surname: user.surname,
          email: user.email,
          i: i
        });
        $("#anotherModal").append(element);
        i = i + 1;
      }
      return $('#anotherModal').foundation('reveal', 'open');
    };

    Gui.prototype.saveNewTrip = function(info) {};

    Gui.prototype.updateTrip = function(id, info) {};

    Gui.prototype.deleteTrip = function(id) {};

    Gui.prototype.participantsTrip = function(id) {};

    Gui.prototype.feedEmptied = function() {};

    Gui.prototype.tripsLoaded = function(Trips) {};

    return Gui;

  })();

  Glue = (function() {
    function Glue(useCase, gui, server) {
      var _this = this;
      this.useCase = useCase;
      this.gui = gui;
      this.server = server;
      After(this.useCase, "showTrips", function(trips) {
        return _this.gui.tripsOnFeed(trips);
      });
      After(this.useCase, "addTripButton", function() {
        return _this.gui.addingTrips();
      });
      After(this.useCase, "showProfile", function(user) {
        return _this.gui.fillThePanel(user);
      });
      After(this.useCase, "showLogIn", function() {
        return _this.gui.logInForm();
      });
      After(this.useCase, "editAndDelete", function(trips) {
        return _this.gui.showEditAndDelete(trips);
      });
      After(this.gui, "saveNewTrip", function(info) {
        return _this.useCase.sendTripOnBackend(info);
      });
      After(this.gui, "updateTrip", function(id, info) {
        return _this.useCase.updateTripOnBackend(id, info);
      });
      After(this.gui, "deleteTrip", function(id) {
        return _this.useCase.deleteTripOnBackend(id);
      });
      After(this.gui, "feedEmptied", function() {
        return _this.useCase.loadTrips();
      });
      After(this.gui, "tripsLoaded", function(trips) {
        return _this.useCase.loadUser(trips);
      });
      After(this.gui, "logInClicked", function(data) {
        return _this.useCase.logInUser(data);
      });
      After(this.gui, "enrollForTrip", function(id) {
        return _this.useCase.joinTheTrip(id);
      });
      After(this.gui, "participantsTrip", function(id) {
        return _this.useCase.getParticipants(id);
      });
      After(this.server, "tripsTaken", function(trips) {
        return _this.useCase.showTrips(trips);
      });
      After(this.server, "reloadMainFeed", function() {
        return _this.gui.refreshTrips();
      });
      After(this.server, "userTaken", function(user, trips) {
        return _this.useCase.showUsersInfo(user, trips);
      });
      After(this.server, "participantsTaken", function(data) {
        return _this.gui.showParticipants(data);
      });
    }

    return Glue;

  })();

  App = (function() {
    function App() {
      var glue, gui, server, usecase;
      server = new Server();
      usecase = new UseCase(server);
      gui = new Gui();
      glue = new Glue(usecase, gui, server);
      usecase.start();
    }

    return App;

  })();

  app = new App();

}).call(this);

/*
//@ sourceMappingURL=camp_app.map
*/
