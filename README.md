# MS Teams Clone

Android app developed for Microsoft Engage 2021. This android app allows users to communicate with Group Video Calling and Text messaging support.

## About me
I'm Akshit Mehra, a Student at MAIT currently pursuing B.Tech in CSE. I'm a third year student and I'm thankful to Microsoft for providing me this opportunity to compete and enhance my skills as an app developer

## The Challenge

Build a Microsoft Teams Clone: The solution should be a fully functional prototype with at least one mandatory functionality - a minimum of two participants should be able connect with each other using the product to have a video conversation

## Technologies Used:

1. __Flutter 2.2__ for implementing the app and UI.
2. __Dart__ for coding the app
3. __Agora API__ for video calling
4. __Google Firebase__ for storing chats and backend
5. Google Login for user login


## AGILE Methodology used for developement

|No. of Days|Methodology|
|-------|------------------|
|2 days| Research about Microsoft Teams and what features it has |
|4 days| Research about various technologies that can be used |
|2 days| Creating a POC |
|3 days| Search all open source projects related to it and find useful info that can be implemented in the app |
|3 days| Creating the basic UI for the app in Figma |
|2+8 days| Coding+Debugging the app |
|2 days| Testing the app and making changes |
|1 day| Making the video and uploading it |

#### Total time took to make the app = 27 days

## Screenshots

This is the splash screen of the app with the logo of the app, it stays for 3 seconds but can be changed.
![Splash Screen](/screenshots/1.jpg width="200" height="200")

The Google Sign In Page and the confirmation box.
![Google Sign in page](/screenshots/2.jpg)  ![Google Sign in page](/screenshots/3.jpg)

All the screens of the homepage: Chats, Rooms and Profile.
![Chats](/screenshots/5.jpg)  ![Rooms](/screenshots/4.jpg)  ![Profile](/screenshots/6.jpg)

The Side Navigation Bar of the app with links to various things including the repository as well as the developers LinkedIn profile.
![Side Bar](/screenshots/7.jpg)

New chats can be created by using the __+__ icon on the Chats screen and new rooms can be made by clicking the __+__ icon on the Rooms screen.
![Create a Chat](/screenshots/8.jpg)  ![Create a Room](/screenshots/9.jpg)

This is the chat screen with chat messages and this app also has in app emojis which will be further upgraded to stickers.
![Chat Screen](/screenshots/12.jpg)  ![Chat Screen with emoji](/screenshots/13.jpg)

This is the room chat screen with chat messages and on clicking the eye button it shows all the members of the app that were added to the room.
![Room Chat Screen](/screenshots/10.jpg)  ![Room Members](/screenshots/11.jpg)
Clicking on the meet button you can create your own meeting with a name and other people in the room can join it.

This is the meeting room with inmeeting chat that is later saved as a message in the room chat which acts as a separate chat is the meeting room with all the messages of the meeting saved in it. 
![Meeting](/screenshots/14.jpg)  ![In meet chat](/screenshots/15.jpg)  ![In meet chat being saved](/screenshots/16.jpg)

## Conclusion

It was a very exciting month for me and I am very happy to say that I created my own Microsoft Teams Clone which works. However being restricted in time due to college exams the app wasn't fully done but it was 90% complete at the time of submittion. Nevertheless it was a profound effort from my side and I am happy the way it turned out. 
If you found any issues while running my app please contact me or raise an issue on github.
This app will still be in development and I will continue working on it and making it better.

## Additional Feature list to be added in the future

1. Turning camera off/on toggle and raising hand button in the meeting.
2. Making the meeting room UI more intuitive.
3. Adding the logo and changing the name of the app.
4. Support for images and files in chats.
5. Adding notifications for the messages.
6. Recording meetings.
7. A calendar in the app for meetings.
8. Supporting than 4 people in a meeting.
9. Adding facial regocnition camera on/off toggle button. (If for 30 seconds no face is detected then the camera will be turned off). 
10. Making contact list better so unknown people can't message each other.
11. Making it more secure and changing null safety to legacy.
12. Making a token server for firebase and implementing it in the app instead of directly using the AppID.
13. Storing messages in an offline database instead of cloud.
14. Changing your profile picture and username in the app.
15. Making it available for ios.
... To be continued

## Known Issues in app

Some minor bugs, like refreshing everytime for a new change to show up on local device and back key not working redirecting to correct page.
