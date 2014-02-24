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

  take_user: (trips) ->
    $.ajax(
        url: "http://campbasebackend.shellyapp.com/user.json"
        type: "GET"
        success: (user) =>
          console.log("success")
          @userTaken(user, trips)
        error: (e) =>
          console.log(e)
          console.log("fail")
        xhrFields: {
            withCredentials: true
        }
        crossDomain: true
        )

  login_user: (data) ->
    $.ajax(
        url:"http://campbasebackend.shellyapp.com/users/sign_in.json"
        type: "POST"
        data:
          email: data[0]
          password: data[1]
        success: (user) =>
          console.log("success")
          @reloadMainFeed()
        error: (e) =>
          console.log(e)
          console.log("fail")
        xhrFields: {
           withCredentials: true
        }
        crossDomain: true
        )

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

  join_the_trip: (id) ->
    $.ajax(
       url: "http://campbasebackend.shellyapp.com/trips/"+id+"/enroll.json"
       type: "GET"
       success: (data, status, response) =>
         console.log("success")
         #alert("You've successfully enrolled for this trip!")
         @reloadMainFeed()
       error: =>
         #alert("Something went wrong. Sorry!") 
         console.log("fail")
       xhrFields: {
            withCredentials: true
        }
        crossDomain: true
       dataType: "json"
       )

  take_participants: (id) =>
    $.ajax(
       url: "http://campbasebackend.shellyapp.com/trips/"+id+"/participants.json"
       type: "GET"
       success: (data, status, response) =>
         console.log(data)
         @participantsTaken(data)
       error: =>
         console.log("fail")
       xhrFields: {
            withCredentials: true
        }
        crossDomain: true
       dataType: "json"
       )

  userTaken: (user, trips) =>

  tripsTaken: (trips) =>

  participantsTaken: =>

  reloadMainFeed: =>


class UseCase
  constructor: (@server) ->

  start: () ->
    console.log("hello")
    @loadInitial()

  showUsersInfo: (User, Trips) =>
    console.log(User)
    if User?
      @showProfile(User)
      if User.admin == true
        @editAndDelete(Trips)
        @addTripButton()
    else
      @showLogIn()

  editAndDelete: (Trips) =>

  showProfile: (user) =>

  showLogIn: =>

  logInUser: (data) =>
    @server.login_user(data)

  loadInitial: =>
    @loadTrips()

  loadUser: (trips) =>
    @server.take_user(trips)

  loadTrips: =>
    @server.take_trips()

  showTrips: (Trips) =>

  addTripButton: =>

  sendTripOnBackend: (info) =>
    @server.save_trip(info)

  updateTripOnBackend: (id, info) =>
    @server.update_trip(id, info)

  deleteTripOnBackend: (id) =>
    @server.delete_trip(id)

  joinTheTrip: (id) =>
    @server.join_the_trip(id)

  getParticipants: (id) =>
    @server.take_participants(id)


  
class Gui
  constructor: ->

  _createElementFor: (templateId, data) =>
    source = $(templateId).html()
    template = Handlebars.compile(source)
    html = template(data)
    element = $(html)

  fillThePanel: (user) =>
    element = @_createElementFor("#profile-template", {photo : user.photo, name : user.name, surname : user.surname})
    $("#userPanel").html(element)
    $("#edit-profile-button").click( => @editProfileClicked(user))

  logInForm: =>
    element = @_createElementFor("#log-in-form-template")
    $("#userPanel").html(element)
    $("#log-in-button").click( => @logInClicked([$("#user-email").val, $("#user-password").val]))
    $("#sign-up-button").click( => @signUpClicked())

  logInClicked: (data) =>

  signUpClicked: =>
    $("#userPanel").empty()
    element = @_createElementFor("#create-profile-template")
    $("#userPanel").html(element)

  editProfileClicked: (user)=>
    $("#userPanel").empty()
    element = @_createElementFor("#edit-profile-template", {photo : user.photo, name : user.name, surname : user.surname, email : user.email})
    $("#userPanel").html(element)

  tripsOnFeed: (Trips) => 
    for trip in Trips
      @showTrip(trip)
    @tripsLoaded(Trips)

  showTrip: (trip) =>
    element = @_createElementFor("#trip-row-template", {photo : trip.photo, name : trip.name, place : trip.place, id : trip.id})
    $("#mainFeed").append(element)
    detailRequest = $("#show-trip-details"+trip.id)
    detailRequest.click( => @tripDetailsClicked(trip.description, trip.id))

  showEditAndDelete: (Trips) =>
    for trip in Trips
      @showOptions(trip)

  showOptions: (trip) =>
    element = @_createElementFor("#edit-delete-template", {id : trip.id})
    $("#trip-"+trip.id).append(element)
    editRequest = $("#edit-trip"+trip.id)
    editRequest.click( => @editTripForm(trip))
    deleteRequest = $("#delete-trip"+trip.id)
    deleteRequest.click( => @deleteTrip(trip.id))
    participantsRequest = $("#participants-trip"+trip.id)
    participantsRequest.click( => @participantsTrip(trip.id))

  tripDetailsClicked: (description, i) =>
    element = @_createElementFor("#show-trip-details-template", {description : description, id : i})
    $("#myModal").html(element)
    $('#myModal').foundation('reveal', 'open')
    signUp = $("#going-on-trip")
    signUp.click( => @enrollForTrip(i))
    $('#myModal').foundation('reveal', 'close')

  enrollForTrip: (i) => 

  editTripForm: (trip)=>
    element = @_createElementFor("#edit-trip-template", {name : trip.name, place : trip.place, from : trip.from, to : trip.to, price : trip.price, photo : trip.photo, description : trip.description})
    $("#editModal").html(element)
    $('#editModal').foundation('reveal', 'open')
    editButton = $("#editTripButton")
    editButton.click(=> @updateTrip(trip.id, [$("#tripName").val(), $("#tripPlace").val(), $("#tripFrom").val(), $("#tripTo").val(), $("#tripPrice").val(), $("#tripPhoto").val(), $("#tripDesc").val()] ))
    $('#editModal').foundation('reveal', 'close')

  addingTrips: =>
    element = @_createElementFor("#add-new-trip-template")
    $("#addField").append(element)
    $("#addNewTrip").click(=> $('#addModal').foundation('reveal', 'open'))
    saveButton = $("#saveTripButton")
    saveButton.click(=> @saveNewTrip([$("#tripName").val(), $("#tripPlace").val(), $("#tripFrom").val(), $("#tripTo").val(), $("#tripPrice").val(), $("#tripPhoto").val(), $("#tripDesc").val()] ))

  refreshTrips: =>
    $("#mainFeed").empty()
    $("#addField").empty()
    @feedEmptied()

  showParticipants: (data) =>
    
    i = 1
    for user in data
      element = @_createElementFor("#participant-template", {name : user.name, surname : user.surname, email : user.email, i : i})
      $("#anotherModal").append(element)
      i = i+1
    $('#anotherModal').foundation('reveal', 'open')

  saveNewTrip: (info) =>

  updateTrip: (id, info) =>

  deleteTrip: (id) =>

  participantsTrip: (id) =>

  feedEmptied: =>

  tripsLoaded: (Trips) =>
    

class Glue
  constructor: (@useCase, @gui, @server)->
    After(@useCase, "showTrips", (trips) => @gui.tripsOnFeed(trips))
    After(@useCase, "addTripButton", => @gui.addingTrips())
    After(@useCase, "showProfile", (user) => @gui.fillThePanel(user))
    After(@useCase, "showLogIn", => @gui.logInForm()) 
    After(@useCase, "editAndDelete", (trips) => @gui.showEditAndDelete(trips))
    After(@gui, "saveNewTrip", (info) => @useCase.sendTripOnBackend(info))
    After(@gui, "updateTrip", (id, info) => @useCase.updateTripOnBackend(id, info))
    After(@gui, "deleteTrip", (id) => @useCase.deleteTripOnBackend(id))
    After(@gui, "feedEmptied", => @useCase.loadTrips())
    After(@gui, "tripsLoaded", (trips) => @useCase.loadUser(trips))
    After(@gui, "logInClicked", (data) => @useCase.logInUser(data))
    After(@gui, "enrollForTrip", (id) => @useCase.joinTheTrip(id))
    After(@gui, "participantsTrip", (id) => @useCase.getParticipants(id))
    After(@server, "tripsTaken", (trips) => @useCase.showTrips(trips))
    After(@server, "reloadMainFeed", => @gui.refreshTrips())
    After(@server, "userTaken", (user, trips) => @useCase.showUsersInfo(user, trips))
    After(@server, "participantsTaken", (data) => @gui.showParticipants(data))

class App
  constructor: ->
    server = new Server()
    usecase = new UseCase(server)
    gui = new Gui()
    glue = new Glue(usecase, gui, server)

    usecase.start()
   


app = new App() 
