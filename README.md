# StoreNews.App (Flutter App &amp; MUS2UE Project)
*Stay informed on the go with StoreNews.*


## Showcase
|  Details |   |
|---|---|
| <img src="./doc/img/detail.jpg" width="300" />  |  <img src="./doc/img/detailexp.jpg" width="300" />  |

| Overview | Store |
|---|---|
| <img src="./doc/img/overview.jpg" width="300" />  |  <img src="./doc/img/store.jpg" width="300" />  |


| Permissions | Notifications |
|---|---|
| <img src="./doc/img/permission.jpg" width="300" />  |  <img src="./doc/img/notification.jpg" width="300" />  |

The mix between english and german is intended, as the app does support internationalization, but the data is defined in the language of the store (in this case german).

## Problem Statement
Store promotions or offers are often overlooked, even though they may be of interest to people passing by. With the help of cleverly placed Bluetooth beacons (as part of Smart City) and a smartphone app, users can receive relevant information in real time. This not only improves the shopping experience, but also enables stores to optimize their marketing strategies and attract potential customers in new ways. 

### User Story
As a user, I want to be able to:  
- [x] Get the latest news of stores on the go. 
- [x] Get notified (but not too often) when I walk past a store that has a new offer.
- [x] View the details of news or offers.
- [x] View and zoom in on news images.
- [x] View the profile of a store with all its latest news and offers.
- [x] See how long offers are valid for.
- [x] Stop the scanning to save battery life and continue when I want to.
- [x] Use dark or light mode.

## Solution
* A Quarkus backend that provides a REST API for the app to fetch data from.
* A flutter app that scans for beacons, fetches data from the backend and displays it to the user.

### Tech Stack
* Flutter (Dart)
  * Material Design 3
  * beacon_plugin (Bluetooth beacons, personalized implementation)
  * i18n (internationalization, only English implemented but extendable)
  * get_it (dependency Injection)
  * flutter_local_notifications (notifications)
  * http (connecting to REST API)
  * permission_handler (request and check permissions)
  * photo_view, carousel_slider (image views, zoomable, scrollable)
* Android (Kotlin)
* Quarkus (Java)
* MongoDB

### Architecture


### Implementation details


## Future TODOs
- [ ] Add more languages
- [ ] Try out Flutter testing
- [ ] Overview of stores near the user
- [ ] Rich Text support in news, clickable links (with security)
- [ ] Design improvements: better list design, fancier UI elements
- [ ] Load more news when scrolling down in the store view







