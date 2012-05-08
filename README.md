MYTwitterEngine
===============

A minimalist Twitter engine for anyone who just wants to post simple text and images.

Install
=========================

To integrate the library with your iOS application, follow the steps below:

    1. Clone the repository. There is already a copy of oauthcomsumer library in the repository, you can get the latest from git://github.com/jdg/oauthconsumer.git
    
    2. Drag the Xcode project package MYTwitterEngine.xcodeproj to your project navigator

    3. Click on your project. Choose the target. Then go to the Build Phases page. 
       Expand "Target Dependencies" and add MYTwitterEngine to the list

    4. In the same Build Phases page, expand "Link Binary With Libraries", add libMYTwitterEngine.a to the list
    
    5. Switch to the Build Settings page, go down to the Search Paths section. (if you have trouble finding it, type "header search" in the search field)
       Add the absolute path to the source code directory to the path list.

    6. Build the project and you are good to go!
    
How to Use
=========================

The library authenticates with Twitter via OAuth, therefore during the workflow you will need to pop up a web view for the user to sign in Twitter account and get the PIN.
The following protocols need to be implemented:

    - [MYTwitterEngineAuthDelegate showAuthWebViewWithURL:]   // called when a web view for showing the Twitter sign-in page is needed
    - [MYTwitterEngineAuthDelegate permissionGrantedWithKey:secret:session:created:duration:renewable:attributes:]    // called when the access token is successfully obtained
    - [MYTwitterEngineAuthDelegate permissionRejectedWithError:]    // called when authentication failed
    
Once the access token is granted, it will be stored in user defaults, and you can start using Twitter resources. Currently the library supports the following operations:

    Post a text only status update
    - [MYTwitterEngine - post:]
    
    Post a status update with picture
    - [MYTwitterEngine - post:withImage:]
    
You have to implement the protocol MYTwitterEngineAuthDelegate to handle case when the API call succeeded or failed:

    - [MYTwitterEngineAPIDelegate apiCall:didFinishWithResponse:]
    - [MYTwitterEngineAPIDelegate apiCall:didFailWithError:]

To see things in action, take a look at the example iPhone app MYTwitterEngineDemo.

Enjoy!