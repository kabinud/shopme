shopme
======

ShopMe is a light-weight shopping list for iOS7. You can get it from AppStore:

https://itunes.apple.com/us/app/shopme/id816599233?mt=8&ign-mpt=uo%3D4

This app implements a custom pull-to-edit gesture and a custom sliding menu. 

You should have a look at the XYZOberViewController.m file first. It is the view controller of the very main view (OberView). It loads the view of items in the current shopping list (MainTableView) and implements the pull-to-edit gesture, which is used to add an item to the list. It also has delegate methods to bring in the top menu. 
