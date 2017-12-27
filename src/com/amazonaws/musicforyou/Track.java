package com.amazonaws.musicforyou;


public class Track {
	private String track_id;
	private String track_name;
	private String artist_name;
	private String album_name;
	private String album_cover;
	private String preview_url;
	private int track_key;
	private double track_tempo;
	public Track(String track_id, String track_name, String artist_name, String album_name, String album_cover, String preview_url, int track_key, double track_tempo){
		this.track_id = track_id;
		this.track_name = track_name;
		this.artist_name = artist_name;
		this.album_name = album_name;
		this.album_cover = album_cover;
		this.preview_url = preview_url;
		this.track_key = track_key;
		this.track_tempo = track_tempo;
	}
	public String getTrack_id() {
		return track_id;
	}
	public String getTrack_name() {
		return track_name;
	}
	 public String getArtist_name() {
		return artist_name;
	}
	public String getAlbum_name() {
		return album_name;
	}
	public String getAlbum_cover() {
		return album_cover;
	}
	public String getPreview_url() {
		return preview_url;
	}
	public int getTrack_key() {
		return track_key;
	}
	public int getTrack_tempo() {
		return (int)track_tempo;
	}
}
