var messages = [
	"Should I do my Math homework?",
	"Should I do my English paper?",
	"Should I go work out?",
	"Should I clean my room?",
	"Should I brush my teeth?",
	"Should I take a shit?",
	"Should I take a piss?",
	"Should I go to class?",
	"Should I go buy food?",
	"Should I go for a run?",
	];



function generateMessage (message) {
<<<<<<< HEAD
	
	$(".owl-message-box").html("<p class='owl-message'>"+message+"</p>");
	$(".owl-message-box").delay(1000).fadeIn(1000).delay(1000).fadeOut(1000, function() {
		$(".owl-message-box").html("<p class='owl-message'> Nah, I'll do it tmrw. </p>")
		$(".owl-message-box").fadeIn(1000).delay(1000).fadeOut(1000, function() { 
			$('.owl-message-box').text(''); 
		});
=======
	ticker = $('#ticker-field');
	ticker.text(message);
	ticker.css({color: 'rgba(0, 0, 0, 0)'});
	ticker.animate({color: 'rgba(0, 0, 0, 1)'}, 1000).delay(2000).animate({color: 'rgba(0, 0, 0, 0)'}, 1000, function() {
		message2 = message;
		while (message2 == message) {
			message2 = messages[Math.floor((Math.random()*messages.length))];
		}
		generateMessage(message2);
>>>>>>> owl
	});
	
};



$(document).ready(function() {

	if ($(".owl-message-box").children().length === 0) {
		generateMessage(messages[Math.floor((Math.random()*messages.length))]);
	} else {
		$(".owl-message-box").fadeIn(1000).delay(1000).fadeOut(1000);
	}


});



