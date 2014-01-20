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

  save_trip: (info) =>
    alert("dupa")
    $.ajax(
       url: "http://0.0.0.0:3000/trips.json"
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
         alert("Dziala! :))))")
       error: =>
         alert("Nie dziala! :((((((((((((((((((((((((((((((((")
       dataType: "json"
       )

  # take_data: ->
  #   $.get 'http://0.0.0.0:3000/name_list', (data) ->
  #     $(".main").append(data)

class UseCase
  constructor: (@server) ->
    @Trips = [{name : "Skiing", place : "Jamaica", photo : "http://www.clker.com/cliparts/5/9/1/e/131294477634010115mountain%20cartoon-th.png",
    description : "SKI!qqqqqqqqqqqqwwwwwertyuiopasdfghjklmnbvcxza"}, 
    {name : "Sailing", place : "Atlantic Ocean", photo : "http://s3.flog.pl/media/foto_mini/613309_ocean-noca.jpg",
    description : "SAIL!mnbvcxzaqwertyuioplkjhgfdsdsdfghjuhjhbffgm,k"},
    {name : "Save the planet!", place : "Moon", photo : "http://img.wikinut.com/img/38.c5n8slo6k3ku0/jpeg/preview/Witch-flying-past-the-moon.jpeg",
    description : "FLY!ertyjkijnhbgvfcdvgnmjnhrbgvfnjewvfjivfjjgbbgbgnjg"}]

  start: () ->
    console.log("hello")
    @showTrips(@Trips)
    @addTripButton()

  showTrips: (Trips) =>

  addTripButton: =>

  sendTripOnBackend: (info) =>
    @server.save_trip(info)

  
class Gui
  constructor: ->

  _createElementFor: (templateId, data) =>
    source = $(templateId).html()
    template = Handlebars.compile(source)
    html = template(data)
    element = $(html)

  tripsOnFeed: (Trips) => 
    i = 0
    for trip in Trips
      @showTrip(trip, i)
      i = i+1

  showTrip: (trip, i) =>
    element = @_createElementFor("#trip-row-template", {photo : trip.photo, name : trip.name, place : trip.place, id : i})
    $("#mainFeed").append(element)
    editRequest = $("#edit-trip"+i)
    editRequest.click( => @editTripForm())
    detailRequest = $("#show-trip-details"+i)
    detailRequest.click( => @tripDetailsClicked(trip.description, i))

  tripDetailsClicked: (description, i) =>
    element = @_createElementFor("#show-trip-details-template", {description : description, id : i})
    $("#myModal").html(element)
    signUp = $("#going-on-trip")
    signUp.click( => @enrollForTrip())

  enrollForTrip: => 
    alert("You've just enrolled for a trip!")

  editTripForm: =>
    element = @_createElementFor("#edit-trip-template")
    $("#editModal").html(element)

  addingTrips: =>
    stupidButton = $("#saveTripButton")
    stupidButton.click(=> @saveNewTrip([$("#tripName").val(), $("#tripPlace").val(), $("#tripFrom").val(), $("#tripTo").val(), $("#tripPrice").val(), $("#tripPhoto").val(), $("#tripDesc").val()] ))

  saveNewTrip: (info) =>
    

class Glue
  constructor: (@useCase, @gui, @server)->
    After(@useCase, "showTrips", (trips) => @gui.tripsOnFeed(trips))
    After(@useCase, "addTripButton", => @gui.addingTrips())
    After(@gui, "saveNewTrip", (info) => @useCase.sendTripOnBackend(info))
    After(@useCase, "sendTripOnBackend", (info) => @server.save_trip(info))

class App
  constructor: ->
    server = new Server()
    usecase = new UseCase(server)
    gui = new Gui()
    glue = new Glue(usecase, gui, server)

    usecase.start()
   


app = new App() 
