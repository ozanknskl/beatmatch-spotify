<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.amazonaws.musicforyou.*" %>
<%@ page import="com.amazonaws.auth.*" %>
<%@ page import="com.amazonaws.services.dynamodbv2.*" %>

<%!
	
	
	private TrackItem instance;
	
%>
<% 
	instance = TrackItem.getInstance();
	String track_id = request.getParameter("id");
	String track_name = request.getParameter("name");
	String artist_name = request.getParameter("artist");
	String album_name = request.getParameter("album");
	String album_cover = request.getParameter("image");
	String preview_url = request.getParameter("url");
	int track_key = Integer.valueOf(request.getParameter("key"));
	double track_tempo = Double.valueOf(request.getParameter("tempo"));
	Track new_track = new Track(track_id,track_name,artist_name,album_name,album_cover,preview_url,track_key,track_tempo);
	System.out.println("Name: " + track_name + " id: " + track_id + " Artist: " + artist_name);
	//System.out.println("Table Status: " + instance.getDB_CLIENT().describeTable(instance.getTABLE_NAME()));

	int result = instance.insertToDB(new_track);
%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Database</title>
</head>
<body>
</body>
</html>
