<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	
	<%@ page import="com.amazonaws.services.dynamodbv2.document.spec.QuerySpec"%>
	<%@ page import="com.amazonaws.musicforyou.*" %>
	<%@ page import= "com.amazonaws.services.dynamodbv2.document.ItemCollection" %>
	<%@ page import= "com.amazonaws.services.dynamodbv2.document.ScanOutcome" %>
	<%@ page import= "com.amazonaws.services.dynamodbv2.document.Item" %>
	<%@ page import= "java.util.*" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	
		
	
	
<%!
	private int key;
	private int bpm_from;
	private int bpm_to;
	private TrackItem instance;
	private ItemCollection<ScanOutcome> items;
	private Iterator<Item> iter;
	private ArrayList<Item> itemList;
	private String image_url;
	private String preview_url;
	private int size;
%>
	
<%
	instance = TrackItem.getInstance();	
	itemList = new ArrayList<>();
	bpm_from = Integer.valueOf(request.getParameter("from_bpm"));
	bpm_to = Integer.valueOf(request.getParameter("to_bpm"));
	key = Integer.valueOf(request.getParameter("trackkey"));
	
	
	System.out.println("bpm from: " + bpm_from);
	System.out.println("bpm to: " + bpm_to);
	System.out.println("track key is: " + key);
	items =	instance.scanTable(key, bpm_from, bpm_to);
	iter = items.iterator();
	while(iter.hasNext()){
		Item item = iter.next();
		System.out.println(item.toString());
		itemList.add(item);
	}
	size = itemList.size();
	
%>

<c:choose> 
	<c:when test="${param.trackkey == 0}">
		<c:set var="key" value="C"/>
	</c:when>
	<c:when test="${param.trackkey == 1}">
		<c:set var="key" value="C#"/>
	</c:when>
	<c:when test="${param.trackkey == 2}">
		<c:set var="key" value="D"/>
	</c:when>
	<c:when test="${param.trackkey == 3}">
		<c:set var="key" value="D#"/>
	</c:when>
	<c:when test="${param.trackkey == 4}">
		<c:set var="key" value="E"/>
	</c:when>
	<c:when test="${param.trackkey == 5}">
		<c:set var="key" value="F"/>
	</c:when>
	<c:when test="${param.trackkey == 6}">
		<c:set var="key" value="F#"/>
	</c:when>
	<c:when test="${param.trackkey == 7}">
		<c:set var="key" value="G"/>
	</c:when>
	<c:when test="${param.trackkey == 8}">
		<c:set var="key" value="G#"/>
	</c:when>
	<c:when test="${param.trackkey == 9}">
		<c:set var="key" value="A"/>
	</c:when>
	<c:when test="${param.trackkey == 10}">
		<c:set var="key" value="A#"/>
	</c:when>
	<c:when test="${param.trackkey == 11}">
		<c:set var="key" value="B"/>
	</c:when>
</c:choose>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>MusicForYou</title>
<link rel="stylesheet" href="bootstrap/css/spotify.css" />
<link rel="stylesheet" href="styles/my_style.css"/>
<script src="bootstrap/js/jquery-3.1.1.min.js"></script>
<script src="bootstrap/js/handlebars-v4.0.5.js"></script>
</head>
<body>
	<div class="my-image"></div>
	<div class="container" id="results">
		<h2 class="text-center"> 
			Results for tracks with key:
			${key}
			and BPM: ${param.from_bpm} - ${param.to_bpm}
		</h2>
		<h3 class="text-center">Please click on the pictures to hear the preview</h3>
		<%
			
		%>
		<c:forEach var="track" items="${itemList}">
			<c:set var="image_url" value="${track.get('image')}"></c:set>
			<p>Image url jstl: ${image_url}</p>
			<div style="background-image:url(${image_url})" class="cover"></div>
		</c:forEach>
		<%
		for(Item it : itemList){
			image_url = (String)it.get("image");
			preview_url = (String)it.get("url");
			
			%>
				<c:set var="image_url_2">
					<%=it.get("image") %>
				</c:set>
				<c:set var="preview_url">
					<%=it.get("url") %>
				</c:set>
				<div class="row row-centered">
					<div class="col-md-8 col-centered">
						<h3>
						<%=it.get("name")%> 
						</h3>
						<h4>
						<%=it.get("artist")%> 
						</h4>
						<p>
						KEY: <strong> ${key} </strong>
						BPM: <strong> <%=it.get("bpm") %> </strong>				
						</p>
						<div  style="background-image:url(${image_url_2});" data-preview-url="${preview_url}" class="cover"  >
						</div>
		
					</div>				
				</div>
				
		<%
		}
		
		%>
		
	</div>
	<script src="bootstrap/js/audioplay.js"></script>

</body>
<footer>
      &copy; Ozan Kınasakal
      <script>
        document.write(new Date().getFullYear());
      </script>.
      Contact me: <a href='mailto:s3620477@student.rmit.edu.au'>s3620477@student.rmit.edu.au</a> 
</footer>
</html>