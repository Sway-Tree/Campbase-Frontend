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

  # take_data: ->
  #   $.get 'http://0.0.0.0:3000/name_list', (data) ->
  #     $(".main").append(data)

class UseCase
  constructor: ->
    @names = ["Anette", "Henry", "Tarja", "Mia", "Callin", "Pauli"]
    @Trips = [{name : "Skiing", destination : "Jamaica", photo : "http://www.clker.com/cliparts/5/9/1/e/131294477634010115mountain%20cartoon-th.png",
    description : "SKI!qqqqqqqqqqqqwwwwwertyuiopasdfghjklmnbvcxza"}, 
    {name : "Sailing", destination : "Atlantic Ocean", photo : "http://s3.flog.pl/media/foto_mini/613309_ocean-noca.jpg",
    description : "SAIL!mnbvcxzaqwertyuioplkjhgfdsdsdfghjuhjhbffgm,k"},
    {name : "Save the planet!", destination : "Moon", photo : "http://img.wikinut.com/img/38.c5n8slo6k3ku0/jpeg/preview/Witch-flying-past-the-moon.jpeg",
    description : "FLY!ertyjkijnhbgvfcdvgnmjnhrbgvfnjewvfjivfjjgbbgbgnjg"}]

  start: ->
    console.log("hello")
    @showTrips(@Trips)

  showTrips: (Trips) =>
  
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
    element = @_createElementFor("#trip-row-template", {photo : trip.photo, name : trip.name, destination : trip.destination, id : i})
    $("#mainFeed").append(element)
    detailRequest = $("#show-trip-details"+i)
    detailRequest.click( => @tripDetailsClicked(trip.description, i))

  tripDetailsClicked: (description, i) =>
    element = @_createElementFor("#show-trip-details-template", {description : description, id : i})
    $("#myModal").html(element)
    editRequest = $("#edit-trip"+i)
    editRequest.click( => @editTripForm())
    signUp = $("#going-on-trip")
    signUp.click( => @enrollForTrip())

  enrollForTrip: => 
    alert("You've just enrolled for a trip!")

  editTripForm: =>
    element = @_createElementFor("#edit-trip-template")
    $("#editModal").html(element)


class Glue
  constructor: (@useCase, @gui)->
    After(@useCase, "showTrips", (trips) => @gui.tripsOnFeed(trips))

class App
  constructor: ->
    server = new Server()
    usecase = new UseCase()
    gui = new Gui()
    glue = new Glue(usecase, gui)

    usecase.start()
   


app = new App() 
