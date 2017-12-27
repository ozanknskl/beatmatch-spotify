var next = 'https://api.spotify.com/v1/me/tracks?limit=50';
//while(next != null){
console.log("trying first ajax with: " + next); 
$.ajax({
	url : next,
	headers : {
		'Authorization' : 'Bearer ' + accessToken
	},
	async : true,
	success : function(response) {
		//alert("success!");
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
		
		if(next != null){
			for(var i=50; i< total; i += 50){
				next_url = "https://api.spotify.com/v1/me/tracks?" + "offset=" + i + "&limit=50";
				sendAjax(next_url);
			}
		}else{
			console.log("no more next page requests!");
		}

	}
});

function sendAjax(next){
	$.ajax({
		url : next,
		headers : {
			'Authorization' : 'Bearer ' + accessToken
		},
		async : true,
		success : function(response) {
			//alert("success!");
			var tracks = response;
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
		},error : function(xhr, textStatus, errorThrown) {
			alert("status: " + textStatus
					+ "error ajax: " + xhr.responseText);
		}
	});
}
