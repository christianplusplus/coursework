function RandomImage(){
	var a;
	a = Math.floor(Math.random() * 7);
	if(a == 0){
		document.getElementById('banner').src = 'images/DS2KnightBanner(cropped).jpg';
	}
	if(a == 1){
		document.getElementById('banner').src = 'images/dragonSlayer(cropped).jpg';
	}
	if(a == 2){
		document.getElementById('banner').src = 'images/knight(cropped).png';
	}
	if(a == 3){
		document.getElementById('banner').src = 'images/blackKnight(cropped).jpg';
	}
	if(a == 4){
		document.getElementById('banner').src = 'images/dark3.jpg';
	}
	if(a == 5){
		document.getElementById('banner').src = 'images/mask.jpg';
	}
	if(a == 6){
		document.getElementById('banner').src = 'images/blueknight.jpg';
	}
}