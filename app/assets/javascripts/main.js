
$(document).on('page:change', function () {

if (localStorage.lastRoom && ($(".room-tab[data-id="+ localStorage.lastRoom +"]").length > 0)) {// if a room preference exists  && it exists in the DOM

		roomTabbing(localStorage.lastRoom); // show it

	}

else if ($(".room-tab").length > 0) { // One exists at all
	firstRoom = $(".room-tab").first().attr("data-id");
	roomTabbing(firstRoom); // show the first one
	}

// ============================[ Room logic] =============

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
				$(".message-section, .room-section").toggleClass("hidden");
				roomTabbing(roomId);
				$(".room-leave").removeClass("hidden");

			}
	});
});

// Select a room

$('html').on('click', ".room-tab", function(){

roomTabbing($(this).attr('data-id'));

});

// Opens up the form

$('.chat').on('click', ".room-add", function(){

	$(".room-form").toggleClass("hidden");
	$(".room-index").toggleClass("hidden");

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
					localStorage.lastRoom = ""

				if ($(".room-tab").length > 0) { // if another room exists...

					nextId = $(".room-tab").last().attr("data-id");
					nextName = $(".room-tab").last().text();
					roomTabbing(nextId); // go there!
					setCookie("lastRoom", nextId); // and make sure it saves
					localStorage.lastRoom = nextId

				}
				else {
					$(".chat-room-active").html("Chat"); // resets the name to Chat
					$(".room-leave").addClass("hidden");
				}

			}
		});

});

// Changes view

$(".view-switch").click(function() {

	$(".message-section, .room-section").toggleClass("hidden");

});

// Switches room

function roomTabbing(roomId) {

	$('#compose').attr('data-room-id', roomId); // change the input target
	$(".room").removeClass("room-active"); // all rooms hide

	$(".room-tab").removeClass("room-tab-active");
	$(".room-tab[data-id="+ roomId +"]").addClass("room-tab-active");
	$(".room-tab[data-id="+ roomId +"]").removeClass("room-tab-new");

	$(".room[data-id="+ roomId +"]").addClass("room-active"); // then show the target room

	name = $(".room-tab[data-id="+ roomId +"]").text();
	$(".chat-title").html(name) // change the header


	chatbottom(); // scroll to bottom
	setCookie("lastRoom", roomId); // saves preference
	localStorage.lastRoom = roomId;

	$(".room-section").addClass("hidden"); // if the user is in add room tab...
	$(".message-section").removeClass("hidden"); // take him out


}




//==============================[ CHAT BOX ]==============

	var intervalID = window.setInterval(poll, 1500);
	originalTitle = $(document).find("title").text();
//	window_focus = true;
	var lastRoom;
	lastId = 0;
	notSeen = 0;
	chatbottom();
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

					lastRoomUser = $(".message-content",".room[data-id="+ this.room +"]").last().attr('data-user-id') || 0

					createdAt = new Date(this.created_at)
					timeAgo = (jQuery.timeago(createdAt));

					if (this.userid != lastRoomUser) {
					$(".room[data-id="+ this.room +"]").append("<div class='message'> <div class='message-user-photo'> <img src='"+ this.photo +"'/></div><div class='message-info-content'><span class='message-user-name'> "+ this.username +" </span> <span class='message-time'> "+ timeAgo +"</span> 	<div class='message-content' data-id='"+ this.id +"' data-user-id='"+ this.userid +"'>" + this.message + "</div></div></div>");
					}
					else {
					$(".message-info-content",".room[data-id="+ this.room +"]").last().append("<div class='message-content' data-id='"+ this.id +"' data-user-id='"+ this.userid +"'>" + this.message + "</div>");
					$(".message-time",".room[data-id="+ this.room +"]").last().text(timeAgo);
					}

					lastRoom = this.room;
					lastId = this.id;					// for pinging more messages
					chatbottom();

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
    if (e.which == 13) {

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
// ================= USER LOGIC=====================

$("#user_username").keypress(function (e) {

	if ($(this).val() != ""){

		$("h3",".chat-insert").css({"height":"30px"});


	}
});
 //=====

$("#show-mobile-chat").click(function(){

	mainPage = !mainPage;
	$(".containerd, .footer-margin, .chat").toggleClass("hidden-mobile");
	$(this).toggleClass("tab-active");
});

$(".toggle-console").click(function(){

	$("#console").toggleClass("console-show");

});


function setCookie(cname, cvalue) {
    var d = new Date();
    d.setTime(d.getTime() + (20*12*30*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}


});
