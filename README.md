# README

This web project is for my "COSC2626 Cloud Computing" assignment at RMIT University,Melbourne. It is a tool that can be used by DJs or producers to find the songs that are in a specified KEY(tone) and BPM range. It can be used for "beatmatching" or "mashups". 
The user can login with its Spotify account to the system and specify a key and BPM range to request the available songs in his/her library. In the resulting page there will be some information about songs and a 30 seconds preview where you can listen by clicking on the album cover picture.

Whenever the user logs in his/her music library in Spotify is synced and recorded to AWS Dynamo DB table. Since I don't currently have an active EC2 instance running, you can run the project in localhost instead, by changing the redirectURI to your localhost in index.jsp file. It is pretty inefficient(takes too much time) while loading all the saved tracks from user's library, that should be improved.

Here are some screenshots from website running:
* Login:

![login](https://user-images.githubusercontent.com/24544546/34382906-c7e66acc-eb22-11e7-8a26-3b96294facc4.png)

* Search:

![search](https://user-images.githubusercontent.com/24544546/34382905-c7b37bda-eb22-11e7-9df6-4787983ecfcc.png)

* Results:

![results](https://user-images.githubusercontent.com/24544546/34382903-c75a0e42-eb22-11e7-8edd-a7e404337e4e.png)

![results](https://user-images.githubusercontent.com/24544546/34382904-c77dff28-eb22-11e7-9e5d-62646bb435cb.png)
