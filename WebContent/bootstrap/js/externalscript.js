//var template = $('#user-profile-template').html();
//var templateScript = Handlebars.compile(template);
var accessToken;
$('#mylogin').show();
$('#myafterlogin').hide();
$('#myinfodiv').show();
$('#myinfodiv2').hide();

if (window.location.hash) {
	document.getElementById("myinfodiv").style.display = "none";
	document.getElementById("mylogin").style.display = "none";
	document.getElementById("myafterlogin").style.display = "none";
	document.getElementById("myinfodiv2").style.display = "none";


	var params = getHashParams();
	accessToken = params.access_token, state = params.state;
	if (state == null || accessToken == null) {
		alert("There was an error during the authentication!");

	} else {

		console.log("Access Token is : " + accessToken);
		console.log("State is: " + state);
		if (accessToken) {
			/*
			$.ajax({
				url: 'sendAjax.jsp?access=' +accessToken,
				success: function(){
					console.log("request sent to ajaxserver");
				}
			});		*/								
			var next = 'https://api.spotify.com/v1/me/tracks?limit=50';
			while(next != null){
				console.log("trying first ajax with: " + next); 
				$.ajax({
					url : next,
					headers : {
						'Authorization' : 'Bearer ' + accessToken
					},
					async : false,
					success : function(response) {

						var tracks = response;
						next = tracks.next;
						console.log("Next URL is: " + next);
						var total = tracks.total;
						var itemsarray = tracks.items;
						for (var i = 0; i < itemsarray.length; i++) {
							var track_id = itemsarray[i].track.id;
							var track_name = itemsarray[i].track.name;
							var artist_name = itemsarray[i].track.artists[0].name;
							var album_name = itemsarray[i].track.album.name;
							var album_cover = itemsarray[i].track.album.images[0].url;
							var preview_url = itemsarray[i].track.preview_url;
							var track_key;
							var track_tempo;
							$.ajax({	
								url: 'https://api.spotify.com/v1/audio-features/' + track_id,
								headers : {
									'Authorization' : 'Bearer ' + accessToken
								},
								async : false,
								success : function(response){
									track_key = response.key;
									track_tempo = response.tempo;
									console.log("Song: " + track_name + " Key: " + track_key + " Tempo: " + track_tempo);
									$.ajax({
										url : 'handleDatabase.jsp',
										data : {
											id: track_id,
											name: track_name,
											artist: artist_name,
											album: album_name,
											image: album_cover,
											url: preview_url,
											key: track_key,
											tempo: track_tempo
										},
										async: false,
										type : "GET",
										success: function(){
											console.log("Track info is sent to database server.");
										},
										error : function(xhr, textStatus, errorThrown) {
											alert("status: " + textStatus
													+ "error ajax: " + xhr.responseText);
										}
									});

								},
								error : function(xhr, textStatus, errorThrown) {
									alert("status: " + textStatus
											+ "error ajax: " + xhr.responseText);
								}
							});
						}
					}
				});
			}
			document.getElementById("myinfodiv2").style.display = "inline";
			document.getElementById("myafterlogin").style.display = "inline";
		} else {
			$('#mylogin').show();
			$('#myafterlogin').hide();
			$('#myinfodiv').show();
			$('#myinfodiv2').hide();
		}
	}
}

function getHashParams() {
	var hashParams = {};
	var e, r = /([^&;=]+)=?([^&;]*)/g, q = window.location.hash
	.substring(1);
	while (e = r.exec(q)) {
		hashParams[e[1]] = decodeURIComponent(e[2]);
	}
	return hashParams;
}
