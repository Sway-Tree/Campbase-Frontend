_.defaults this,
  Before: (object, methodName, adviseMethod) ->
    YouAreDaBomb(object, methodName).before(adviseMethod)
  BeforeAnyCallback: (object, methodName, adviseMethod) ->
    YouAreDaBomb(object, methodName).beforeAnyCallback(adviseMethod)
  After: (object, methodName, adviseMethod) ->
    YouAreDaBomb(object, methodName).after(adviseMethod)
  Around: (object, methodName, adviseMethod) ->
    YouAreDaBomb(object, methodName).around(adviseMethod)


class Server
  constructor: ->

  take_trips: ->
    $.ajax(
        url: "http://campbasebackend.shellyapp.com/trips.json"
        type: "GET"
        success: (trips) =>
          console.log("success")
          @tripsTaken(trips)
        error: =>
          console.log("fail")
        )

  save_trip: (info) ->
    $.ajax(
       url: "http://campbasebackend.shellyapp.com/trips.json"
       type: "POST"
       data:
         name: info[0]
         place: info[1]
         from: info[2]
         to: info[3]
         price: info[4]
         photo: info[5]
         description: info[6]
       success: (data, status, response) =>
         console.log("success")
         @reloadMainFeed()
       error: =>
         console.log("fail")
       dataType: "json"
       )

  update_trip: (id, info) ->
    $.ajax(
       url: "http://campbasebackend.shellyapp.com/trips/"+id+".json"
       type: "PUT"
       data:
         name: info[0]
         place: info[1]
         from: info[2]
         to: info[3]
         price: info[4]
         photo: info[5]
         description: info[6]
       success: (data, status, response) =>
         console.log("success")
         @reloadMainFeed()
       error: =>
         console.log("fail")
       dataType: "json"
       )

  delete_trip: (id) ->
    $.ajax(
       url: "http://campbasebackend.shellyapp.com/trips/"+id+".json"
       type: "DELETE"
       success: (data, status, response) =>
         console.log("success")
         @reloadMainFeed()
       error: =>
         console.log("fail")
       dataType: "json"
       )

  tripsTaken: (trips) =>

  reloadMainFeed: =>


class UseCase
  constructor: (@server) ->

  start: () ->
    console.log("hello")
    @Trips = @server.take_trips()
    @addTripButton()

  loadTrips: =>
    @Trips = @server.take_trips()

  showTrips: (Trips) =>

  addTripButton: =>

  sendTripOnBackend: (info) =>
    @server.save_trip(info)

  updateTripOnBackend: (id, info) =>
    @server.update_trip(id, info)

  deleteTripOnBackend: (id) =>
    @server.delete_trip(id)


  
class Gui
  constructor: ->

  _createElementFor: (templateId, data) =>
    source = $(templateId).html()
    template = Handlebars.compile(source)
    html = template(data)
    element = $(html)

  tripsOnFeed: (Trips) => 
    for trip in Trips
      @showTrip(trip)

  showTrip: (trip) =>
    element = @_createElementFor("#trip-row-template", {photo : trip.photo, name : trip.name, place : trip.place, id : trip.id})
    $("#mainFeed").append(element)
    editRequest = $("#edit-trip"+trip.id)
    editRequest.click( => @editTripForm(trip))
    deleteRequest = $("#delete-trip"+trip.id)
    deleteRequest.click( => @deleteTrip(trip.id))
    detailRequest = $("#show-trip-details"+trip.id)
    detailRequest.click( => @tripDetailsClicked(trip.description, trip.id))

  tripDetailsClicked: (description, i) =>
    element = @_createElementFor("#show-trip-details-template", {description : description, id : i})
    $("#myModal").html(element)
    $('#myModal').foundation('reveal', 'open')
    signUp = $("#going-on-trip")
    signUp.click( => @enrollForTrip())
    $('#myModal').foundation('reveal', 'close')

  enrollForTrip: => 
    alert("You've just enrolled for a trip!")

  editTripForm: (trip)=>
    element = @_createElementFor("#edit-trip-template", {name : trip.name, place : trip.place, from : trip.from, to : trip.to, price : trip.price, photo : trip.photo, description : trip.description})
    $("#editModal").html(element)
    $('#editModal').foundation('reveal', 'open')
    editButton = $("#editTripButton")
    editButton.click(=> @updateTrip(trip.id, [$("#tripName").val(), $("#tripPlace").val(), $("#tripFrom").val(), $("#tripTo").val(), $("#tripPrice").val(), $("#tripPhoto").val(), $("#tripDesc").val()] ))
    $('#editModal').foundation('reveal', 'close')

  addingTrips: =>
    saveButton = $("#saveTripButton")
    saveButton.click(=> @saveNewTrip([$("#tripName").val(), $("#tripPlace").val(), $("#tripFrom").val(), $("#tripTo").val(), $("#tripPrice").val(), $("#tripPhoto").val(), $("#tripDesc").val()] ))

  refreshTrips: =>
    $("#mainFeed").empty()
    @feedEmptied()

  saveNewTrip: (info) =>

  updateTrip: (id, info) =>

  deleteTrip: (id) =>

  feedEmptied: =>
    

class Glue
  constructor: (@useCase, @gui, @server)->
    After(@useCase, "showTrips", (trips) => @gui.tripsOnFeed(trips))
    After(@useCase, "addTripButton", => @gui.addingTrips())
    After(@gui, "saveNewTrip", (info) => @useCase.sendTripOnBackend(info))
    After(@gui, "updateTrip", (id, info) => @useCase.updateTripOnBackend(id, info))
    After(@gui, "deleteTrip", (id) => @useCase.deleteTripOnBackend(id))
    After(@gui, "feedEmptied", => @useCase.loadTrips())
    After(@server, "tripsTaken", (trips) => @useCase.showTrips(trips))
    After(@server, "reloadMainFeed", => @gui.refreshTrips())

class App
  constructor: ->
    server = new Server()
    usecase = new UseCase(server)
    gui = new Gui()
    glue = new Glue(usecase, gui, server)

    usecase.start()
   


app = new App() 
