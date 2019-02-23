# iPrayer (test branch is the main)

This is my final project for the Udacity "iOS Developer Nanodegree" Program:

# Table of Contents
* [App Description](#description)<br />
* [Project Details](#projectdetails)<br />
* [Feature Wishlist](#features)

<a name="description">

## App Description

This app built for Halghe Mysticism users to help them to their practices. They can add their own Ertebat (a type of meditation in Halghe Mysticism) list. Because the user should practice together, each practice that creates by user share to the community. Once the practice is displayed in a table view, the user can select a practice to open a detail view of that practice. In the detail view. 

Furthermore, users can write a comment about each practice. 
Also in the News tab bar users can see the latest News about the Halghe Mysticism and see the detail of news in the detail page.
<a name="projectdetails">

## Project Details

### User Interface

* Four main View Controllers:
  - Authentication View Controller
  - User Practice View Controller
  - Other User Practice View Controller
  - News View Controller
* Three of main View Controllers are using Table View and Collection View
* Other View Controllers:
* Add Practice View Controller
* Detail Practice View Controller
* Detail News View Controller
* Profile View Controller

### Networking

* Using Firebase database for Authentication
* Using Firebase database for POST/GET user practice
* Using Firebase realtime database for sent comment between user 
* Halghe NEWS API is used to retrieve last news:
  - Title 
  - News Link
  - Publication Date
  - News Cover Image
* While an online news get is in progress, an Activity Indicator is displayed
* An alert view will be displayed, if there was a network error


### Persistence

* User Practice added to the Practice List are stored in Core Data
* Choice of book sorting by creation date 

## Feature Wishlist

Some ideas for additional features:

* Persian localization
* Set timer for each Practice
* Switch between grid/list view of practice added
* Add user categories / Filter by categories (pilgrim or master)
* Allow to add tags and filter by multiple tags
* Show a longer description of the news
* Include other APIs, e.g. Twitter
* User can follow each other
* iPad version
* ...
