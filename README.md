# GitHubUserAndFollowers

This app build on using Xcode version 11.2.1 , Swift 5 and iOS version 12.4 .


To run this app, open terminal and clone this app by using below command

git clone https://github.com/SreekanthGudisi/GitHubUserAndFollowers.git



Open the project and run on simulator or actual divice ,

1. Serach by Github account username if username not found you will get an Alert.

2. If your name found it will go Details ViewController.  In Details Screen you can see Username, Email And Avatar. 

3. If user has followers, you can see list of followers in tableview like followers Name and Avatar.


// Design Pattern
 
Here I have used like

1. SingleTon Design pattern

     By Storing API's response into SharedInformation class
     
1. Decorator Design pattern.
     
     By using Extension 
     
2. TableView Delegate Design pattern

     By using TableView heightForRowAt
     
3. TextField Delegate Design pattern
    
     By using thi smethods, 
            a) textFieldShouldReturn
            b) textFieldDidBeginEditing
            c) textFieldDidEndEditing
