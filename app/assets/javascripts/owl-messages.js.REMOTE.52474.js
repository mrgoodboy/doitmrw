var messages = [
	"do my Math homework",
	"do my English paper",
	"go work out",
	"clean my room",
	"brush my teeth",
	"take a shit",
	"take a piss",
	"go to class",
	"go buy food",
	"go for a run"
	];



function generateMessage (message) {
	ticker = $('#ticker-field');
	ticker.text(message);
	ticker.css({color: 'rgba(0, 0, 0, 0)'});
	ticker.animate({color: 'rgba(0, 0, 0, 1)'}, 1000).delay(2000).animate({color: 'rgba(0, 0, 0, 0)'}, 1000, function() {
		message2 = message;
		while (message2 == message) {
			message2 = messages[Math.floor((Math.random()*messages.length))];
		}
		generateMessage(message2);
	});
}



$(document).ready(function() {

	generateMessage(messages[Math.floor((Math.random()*messages.length))]);

});



