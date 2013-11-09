var messages = [
"do my Math homework",
"do my English paper",
"go work out",
"clean my room",
"brush my teeth",

"go to class",
"go buy food",
"go for a run",
"what does the owl say",
"write my English paper",
"do work",
"get off this site",
"take a shower",
"go buy groceries",
"stop playing video games",
"check my email",
"go on a run",
"go to the gym",
"go to class",
"do my homework",
"get a haircut",
"brush my teeth",
"leave my room",
"do my problem set",
"code an app",
"sleep",
"eat",
"play a sport",
"watch TV",
"talk to people",
"be productive"
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



