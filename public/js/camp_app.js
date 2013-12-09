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
    function Server() {}

    return Server;

  })();

  UseCase = (function() {
    function UseCase() {
      this.showTrips = __bind(this.showTrips, this);
      this.names = ["Anette", "Henry", "Tarja", "Mia", "Callin", "Pauli"];
      this.Trips = [
        {
          name: "Skiing",
          destination: "Jamaica",
          photo: "http://www.clker.com/cliparts/5/9/1/e/131294477634010115mountain%20cartoon-th.png",
          description: "SKI!qqqqqqqqqqqqwwwwwertyuiopasdfghjklmnbvcxza"
        }, {
          name: "Sailing",
          destination: "Atlantic Ocean",
          photo: "http://s3.flog.pl/media/foto_mini/613309_ocean-noca.jpg",
          description: "SAIL!mnbvcxzaqwertyuioplkjhgfdsdsdfghjuhjhbffgm,k"
        }, {
          name: "Save the planet!",
          destination: "Moon",
          photo: "http://img.wikinut.com/img/38.c5n8slo6k3ku0/jpeg/preview/Witch-flying-past-the-moon.jpeg",
          description: "FLY!ertyjkijnhbgvfcdvgnmjnhrbgvfnjewvfjivfjjgbbgbgnjg"
        }
      ];
    }

    UseCase.prototype.start = function() {
      console.log("hello");
      return this.showTrips(this.Trips);
    };

    UseCase.prototype.showTrips = function(Trips) {};

    return UseCase;

  })();

  Gui = (function() {
    function Gui() {
      this.editTripForm = __bind(this.editTripForm, this);
      this.enrollForTrip = __bind(this.enrollForTrip, this);
      this.tripDetailsClicked = __bind(this.tripDetailsClicked, this);
      this.showTrip = __bind(this.showTrip, this);
      this.tripsOnFeed = __bind(this.tripsOnFeed, this);
      this._createElementFor = __bind(this._createElementFor, this);
    }

    Gui.prototype._createElementFor = function(templateId, data) {
      var element, html, source, template;
      source = $(templateId).html();
      template = Handlebars.compile(source);
      html = template(data);
      return element = $(html);
    };

    Gui.prototype.tripsOnFeed = function(Trips) {
      var i, trip, _i, _len, _results;
      i = 0;
      _results = [];
      for (_i = 0, _len = Trips.length; _i < _len; _i++) {
        trip = Trips[_i];
        this.showTrip(trip, i);
        _results.push(i = i + 1);
      }
      return _results;
    };

    Gui.prototype.showTrip = function(trip, i) {
      var detailRequest, element,
        _this = this;
      element = this._createElementFor("#trip-row-template", {
        photo: trip.photo,
        name: trip.name,
        destination: trip.destination,
        id: i
      });
      $("#mainFeed").append(element);
      detailRequest = $("#show-trip-details" + i);
      return detailRequest.click(function() {
        return _this.tripDetailsClicked(trip.description, i);
      });
    };

    Gui.prototype.tripDetailsClicked = function(description, i) {
      var editRequest, element, signUp,
        _this = this;
      element = this._createElementFor("#show-trip-details-template", {
        description: description,
        id: i
      });
      $("#myModal").html(element);
      editRequest = $("#edit-trip" + i);
      editRequest.click(function() {
        return _this.editTripForm();
      });
      signUp = $("#going-on-trip");
      return signUp.click(function() {
        return _this.enrollForTrip();
      });
    };

    Gui.prototype.enrollForTrip = function() {
      return alert("You've just enrolled for a trip!");
    };

    Gui.prototype.editTripForm = function() {
      var element;
      element = this._createElementFor("#edit-trip-template");
      return $("#editModal").html(element);
    };

    return Gui;

  })();

  Glue = (function() {
    function Glue(useCase, gui) {
      var _this = this;
      this.useCase = useCase;
      this.gui = gui;
      After(this.useCase, "showTrips", function(trips) {
        return _this.gui.tripsOnFeed(trips);
      });
    }

    return Glue;

  })();

  App = (function() {
    function App() {
      var glue, gui, server, usecase;
      server = new Server();
      usecase = new UseCase();
      gui = new Gui();
      glue = new Glue(usecase, gui);
      usecase.start();
    }

    return App;

  })();

  app = new App();

}).call(this);

/*
//@ sourceMappingURL=camp_app.map
*/
