
$(document).on('page:change', function () {

lastRoom = getCookie("lastRoom"); // The last room visited

if (lastRoom && ($(".room-tab[data-id="+ lastRoom +"]").length > 0)) {// if a room preference exists  && it exists in the DOM
	roomTabbing(lastRoom); // show it
	}

// ============================[ Window logic] =================

$(".room-new").click(function() {

	windowTabbing("room-new");

});

$(".side-back").click(function() {

	windowTabbing("main");

});

$(".room-back").click(function() {

	roomTabOut();
	$(".chat").addClass("hidden-mobile");
	$(".control").removeClass("hidden-mobile");

});

$(".profile-edit").click(function() {

	windowTabbing("profile-edit");

});


function windowTabbing(name){

	target = $(".window-"+ name)

	$(".window").addClass("hidden");
	target.removeClass("hidden");
	$(".side-title").text(target.attr("data-name"));

	if (name != "main"){
		$(".side-back").removeClass("hidden");
		$(".side-actions").addClass("hidden");
	}
	else
	{
		$(".side-back").addClass("hidden");
		$(".side-actions").removeClass("hidden");

	}

}
// ============================[ Room logic] =============

// Show landing

$(".explore").click(function() {

	$(".chat-title").text("Popular"); // resets the name to Lero
	$(".room-actions").addClass("hidden");
	$(".landing").removeClass("hidden");
	$("#compose").addClass("hidden");
	$(".room").removeClass("room-active");
	$(".room-tab").removeClass("room-tab-active");
	$(".landing-intro").addClass("hidden");
	$("#chat-container").addClass("full-height");
	$(".form-username").addClass("hidden");

	displayChat();
});

//Join a room

$(".room-pick").click(function() {

	roomId = $(this).attr('data-id');
	roomName = $(this).text();
	$(this).remove();

	$.ajax({
			url: "/room/join/" + roomId,
			type: "POST",
			complete: function(data) {

				$(".room-tabs").append("<li data-id="+ roomId +" class='room-tab'> "+ roomName + " </li>");
				$("#chat-container").append("<div class='room room-active' data-id="+ roomId +"> </div>");
				roomTabbing(roomId);

			}
	});
});


$(".room-card").click(function() {

	roomId = $(this).attr('data-id');
	roomName = $("h6",this).text();

	if ($(".room-tab[data-id="+ roomId +"]").length > 0) {
		roomTabbing(roomId);
	}
	else {

		$.ajax({
				url: "/room/join/" + roomId,
				type: "POST",
				complete: function(data) {
					$(".room-tabs").append("<li data-id="+ roomId +" class='room-tab'> "+ roomName + " </li>");
					$("#chat-container").append("<div class='room room-active' data-id="+ roomId +"> </div>");
					roomTabbing(roomId);
				}
		});
	}

});


// Select a room

$('html').on('click', ".room-tab", function(){

	roomTabbing($(this).attr('data-id'));

});

//Leave a room

$(".room-leave").click(function() {

	roomId = $(".room-active").attr('data-id');

	$.ajax({
			url: "/room/leave/" + roomId,
			type: "POST",
			complete: function(data) {
				$(".room-tab[data-id="+ roomId +"]").remove(); //remove the tab from DOM
				$(".room-active").remove();// remove this room
					setCookie("lastRoom", ""); // clear cookie
					roomTabbing();
			}
		});

});

$(".room-hotlink").click(function() {

	roomId = $(".room-active").attr('data-id');

	$.ajax({
			url: "/room/share/" + roomId,
			type: "GET",
			success: function(data, textStatus) {

				createdAt = new Date();
				message = "Link para compartilhar: http://localhost:3000/?join=" + data.shareurl

				leroyPrint(message, roomId);
				chatbottom();

			}
		});

});

// Switches room

function roomTabOut() {

		$(".room").removeClass("room-active"); // all rooms hide
		$(".room-tab").removeClass("room-tab-active"); // Remove all rooms as active
		$(".room-actions").removeClass("hidden");
		setCookie("lastRoom", ""); // saves preference

}

function roomTabbing(roomId) {

	if (!roomId){ // Room not set

		if ($(".room-tab").length > 0) { // if another room exists...
			roomId = $(".room-tab").last().attr("data-id");
		}
		else {
			$(".chat-title").text("Lero"); // resets the name to Lero
			$(".room-actions").addClass("hidden");
			$(".landing").removeClass("hidden");
			$("#compose").addClass("hidden");
			return;
		}
	}

	displayChat();
//	document.getElementById("compose").focus();
	$(".form-username").removeClass("hidden");
	$("#chat-container").removeClass("full-height");


	$(".landing").addClass("hidden");
	$("#compose").removeClass("hidden");

	$('#compose').attr('data-room-id', roomId); // change the input target
	$(".room").removeClass("room-active"); // all rooms hide

	$(".room-tab").removeClass("room-tab-active"); // Remove all rooms as active
	$(".room-tab[data-id="+ roomId +"]").addClass("room-tab-active"); // this room mark as active
	$(".room-tab[data-id="+ roomId +"]").removeClass("room-tab-new"); // Remove room notifications

	$(".room[data-id="+ roomId +"]").addClass("room-active"); // then show the target room

	name = $(".room-tab[data-id="+ roomId +"]").text();
	$(".chat-title").text(name) // change the header

	$(".room-actions").removeClass("hidden");

	chatbottom(); // scroll to bottom
	setCookie("lastRoom", roomId); // saves preference
//	localStorage.lastRoom = roomId;

}

//==============================[ CHAT BOX ]==============

	var intervalID = window.setInterval(poll, 1500);
	originalTitle = $(document).find("title").text();
//	window_focus = true;
	var lastRoom;
	lastId = 0;
	notSeen = 0;
	window_focus = true;
	firstPoll = true;
	poll();

// Attach a notification number to web page title
	$(window).focus(function() {

			document.title = originalTitle;
			notSeen = 0;
			window_focus = true;
			//clear notification title
		}).blur(function() {
			window_focus = false;
	});

// Scrolls bottom when it's called

function chatbottom() {
 var objDiv = document.getElementById("chat-container");
 objDiv.scrollTop = objDiv.scrollHeight;
}

// Fires for updates
function poll() {

activeTab = parseInt($(".room-tab-active").attr("data-id"));

	$.ajax({
	    url: "/message/receive/" + lastId,
			timeout: 1000,
	    type: "GET",
	    complete: function(data) {
				response = data.responseText;

				$(jQuery.parseJSON(response)).each(function() {

					createdAt = new Date(this.created_at) //convert to JS time format

					chatPrint(this.id, this.message, this.room, createdAt, this.userid, this.username, this.photo);

					lastRoom = this.room;
					lastId = this.id;					// for pinging more messages

					if ($(".room-tab-active").length > 0){
						chatbottom();
					}

					if (localStorage.lastSaw < lastId && activeTab != this.room) {
						$(".room-tab[data-id="+ this.room +"]").addClass("room-tab-new"); // Alert tabs
					}

					if (!window_focus){
					notSeen += 1;
					}

				});

				localStorage.lastSaw = (lastId - notSeen);
				firstPoll = false;
			}
	});

	if (notSeen > 0 && !window_focus) {
		document.title = "("+ notSeen +") " + originalTitle;
	}

}

 // Auto resize textarea on typing
/*
 function autoline(e) {
   $(e).css({'height':'auto','overflow-y':'hidden'}).height(e.scrollHeight);
 }
 $('textarea').each(function () {
   autoline(this);
 }).on('input', function () {
   autoline(this);
 });
*/
// Prevent scrolling page

$('#chat-container').bind('mousewheel', function(e){
	$(this).scrollTop($(this).scrollTop()-e.originalEvent.wheelDeltaY);
  return false;
});

//Send on enter press

$("#compose").keypress(function (e) {
    if (e.which == 13 && !e.shiftKey) {

			if ($(this).val() == ""){
				return false;
			}

			$.ajax({
					url: "/message/send",
					type: "POST",
					data: {
						roomId: $(this).attr("data-room-id"),
						message: $(this).val(),
					},
					success: function() {
					}
				});

			$(this).val("");
      e.preventDefault();
      }
  });

// ======== Session logic =======

$(".login-button").click(function() {

	$(".form-login").removeClass("hidden");
	$(".form-new-user").addClass("hidden");

	$("#chat-container").removeClass("full-height");
	$(".form-username").removeClass("hidden");

	displayChat();

});

 //=====

function displayMenu(){

	$(".chat").addClass("hidden-mobile");
	$(".control").removeClass("hidden-mobile");

}

function displayChat(){

	$(".chat").removeClass("hidden-mobile");
	$(".control").addClass("hidden-mobile");

}



$(".toggle-console").click(function(){

	$("#console").toggleClass("console-show");

});

function chatPrint(id, message, roomId, createdAt, userId, userName, userPhoto) {

	timeAgo = (jQuery.timeago(createdAt));

	lastRoomUser = $(".message-content",".room[data-id="+ roomId +"]").last().attr('data-user-id') || 0

	if (userId != lastRoomUser) {
	$(".room[data-id="+ roomId +"]").append("<div class='message'> <div class='message-user-photo'> <img src='"+ userPhoto +"'/></div><div class='message-info-content'><span class='message-user-name'> "+ userName +" </span> <span class='message-time'> "+ timeAgo +"</span> 	<div class='message-content' data-id='"+ id +"' data-user-id='"+ userId +"'>" + message + "</div></div></div>");
	}
	else {
	$(".message-info-content",".room[data-id="+ roomId +"]").last().append("<div class='message-content' data-id='"+ id +"' data-user-id='"+ userId +"'>" + message + "</div>");
	$(".message-time",".room[data-id="+ roomId +"]").last().text(timeAgo);
	}

}

function leroyPrint (message, roomId){ // Print a client-side message as leroy

	createdAt = new Date();
	chatPrint("", message, roomId, createdAt, -1, "Leroy", "");

}

function setCookie(cname, cvalue) {
    var d = new Date();
    d.setTime(d.getTime() + (20*12*30*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
    }
    return "";
}

});
