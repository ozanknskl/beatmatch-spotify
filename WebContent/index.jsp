<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="com.amazonaws.musicforyou.*" %>	
<%@ page import="com.amazonaws.*"%>
<%@ page import="com.amazonaws.auth.*"%>
<%@ page import="com.amazonaws.auth.profile.*"%>
<%@ page import="com.amazonaws.services.ec2.*"%>
<%@ page import="com.amazonaws.services.ec2.model.*"%>
<%@ page import="com.amazonaws.services.s3.*"%>
<%@ page import="com.amazonaws.services.s3.model.*"%>
<%@ page import="com.amazonaws.services.dynamodbv2.*"%>
<%@ page import="com.amazonaws.services.dynamodbv2.model.*"%>

<%!// Share the client objects across threads to
	// avoid creatingnew clients for each web request
	private TrackItem instance;
	private AmazonEC2 ec2;
	private AmazonS3 s3;
	private AmazonDynamoDB dynamo;
	private AWSCredentialsProvider credentialsProvider;
	private String url;
	private final String clientID = "";

	private final String redirectURI = "";
	
	private final String scope = "playlist-read-private%20playlist-read-collaborative%20user-follow-read%20user-library-read%20user-top-read";%>

<%
	instance = TrackItem.getInstance();
	/*
	 * AWS Elastic Beanstalk checks your application's health by periodically
	 * sending an HTTP HEAD request to a resource in your application. By
	 * default, this is the root or default resource in your application,
	 * but can be configured for each environment.
	 *
	 * Here, we report success as long as the app server is up, but skip
	 * generating the whole page since this is a HEAD request only. You
	 * can employ more sophisticated health checks in your application.
	 */
	
%>


<%
	//request authorization 
	url = "https://accounts.spotify.com/authorize";
	url += "?response_type=token";
	url += "&client_id=" + clientID;

	url += "&redirect_uri=" + redirectURI;
	url += "&scope=" + scope;
	url += "&state=123";
	url += "&show_dialog=true";
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="bootstrap/css/spotify.css" />
<link rel="stylesheet" href="styles/my_style.css"  />
<script src="bootstrap/js/jquery-3.1.1.min.js"></script>

<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>BeatMatch</title>

<style>
	footer {
		position: fixed;
		bottom: 0px;
	}
</style>
</head>
<body>
	<div class="my-image"></div>
	<div class="container">
		<div class="row row-centered">
			<h2>BeatMatch</h2>
			<div id="mylogin">
				<h3>Log in with your Spotify account to select songs with specified KEY and BPM!</h3>
				<h5>Please wait while we are syncing your saved tracks to database after you login.</h5>
				<h5>This may take some time if you have a lot of tracks in your library, please do NOT close this window.</h5>
				<a href=<%=url%> class="btn btn-primary" role="button">Login with
					Spotify</a>
			</div>
			
			<div id="myinfodiv">
				
			</div>
			<div id="myinfodiv2">
				<h3>Thank you for your patience, now you can search for songs with specified KEY value and BPM range below!</h3>
			</div>
			
			<div id="myafterlogin">
				<form action="showTracks.jsp" class="form-horizontal">
					<div class="form-group">
	        			<span class="col-md-2 control-label"><strong>BPM</strong></span>
	        			<div class="col-md-6">
	           				<div class="form-group row">
	               				<label for="fromBPM" class="col-md-1 control-label">From:</label>
	               				<div class="col-md-2">
	                   				<input type="number" class="form-control" name="from_bpm" placeholder="110">
	               				</div>
	               				<label for="toBPM" class="col-md-1 control-label">To:</label>
	               				<div class="col-md-2">
	                   				<input type="number" class="form-control" name="to_bpm" placeholder="120">
				                </div>
				            </div>
				        </div>
				    </div>
					<div class="form-group">
						<span class="col-md-2 control-label"><strong>KEY</strong></span>
						<div class="col-xs-2">
								<select class="form-control" name="trackkey">
								<option value="0">C</option>
								<option value="1">C#</option>
								<option value="2">D</option>
								<option value="3">D#</option>
								<option value="4">E</option>
								<option value="5">F</option>
								<option value="6">F#</option>
								<option value="7">G</option>
								<option value="8">G#</option>
								<option value="9">A</option>
								<option value="10">A#</option>
								<option value="11">B</option>
							</select>
						</div>
					  </div>
					  <button type="submit" class="btn btn-primary">Search</button>
					</form>
			</div>
		</div>
	</div>
</body>
<footer>
      &copy; Ozan Kınasakal
      <script>
        document.write(new Date().getFullYear());
      </script>.
      Contact me: <a href='mailto:s3620477@student.rmit.edu.au'>s3620477@student.rmit.edu.au</a> 
      	<script src="bootstrap/js/externalscript.js"></script>
      
</footer>
</html>
	
