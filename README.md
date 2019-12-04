# GitHubUserAndFollowers

This app build on using Xcode version 11.2.1 , Swift 5 and iOS version 12.4 .


To run this app, open terminal and clone this app by using below command

git clone https://github.com/SreekanthGudisi/GitHubUserAndFollowers.git



Open the project and run on simulator or actual divice,

1. Serach by Github account username if username not found you will get an Alert.

2. If your name found it will go to Details ViewController.  In Details Screen you can see Username, Email And Avatar. 

3. If user has followers, Here I have given condition to show list of followers.

     a) The conditon is: GitHub user has more than 100 repos and 100 followers, then only Im showing the follower details (like  Name and Avatar).
     
     b) The API is : https://api.github.com/search/users?q=\(userName)+repos:>100+followers:>100 . So in serach screen, type tom as userName.

// Used Design Patterns like :
1. SingleTon Design Pattern

     By storing API's response into SharedInformation class
     
1. Decorator Design Pattern.
     
     By using Extension 
     
2. TableView Delegate Design Pattern

     By using heightForRowAt method
     
3. TextField Delegate Design Pattern
    
     By using textFieldShouldReturn method
          

// Cache system for all the images :

       I have stroed all images Cache into dictonary from API call. Once API is calling all images will save into cache into dictonary. Next time onwords showing images from Cache. So no need of loading all images from API. 
   

// Lazy loading

       Doing lazy loading also to reduce the memory management.




// Look at Video and Screen shots from Image folder
