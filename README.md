## **List of group member names**
Made Izzy Prema Darma <br>
Damar Aryaputra Rahman <br> 
Serafina Nala Putri Setiawan <br>
William Samuel Mulya <br>
Zakiy Makarim Iskandar Daulay <br>
Muhammad Brian Subekti <br>

## **Link to the APK**
Coming Soon !

## **Application description**
Our website aims to provide easy access for travelers to discover a wide range of unique accommodations in Bali, from beachfront villas to cozy inland bungalows. The platform facilitates seamless interactions between hosts and guests, offering features like real-time booking, user reviews, and personalized recommendations based on user preferences. This will make the experience of visiting Bali more enjoyable and convenient while also supporting local hosts in promoting their properties.

The website addresses the challenges travelers face when searching for accommodations that suit their needs, especially with the abundance of options available. Additionally, local hosts often need a user-friendly platform to showcase their properties and engage with guests efficiently. Our platform solves these issues by offering diverse accommodation options along with easy booking and communication features.

The main users of this platform are global travelers seeking a simpler, more personalized way to find and book accommodations in Bali. Local hosts will also benefit from having an efficient platform to manage bookings, promote their properties, and connect with guests, ultimately boosting their income and supporting the local economy.

The website helps travelers by providing detailed property descriptions, user reviews, and an easy-to-navigate booking process, allowing them to plan their trips effortlessly. For hosts, the platform offers a streamlined way to manage bookings, promote their accommodations, and engage directly with guests, leading to increased opportunities for income and visibility.

## **List of modules implemented and division of work among group members**
* Hotel management module ( can be accessed by host), Host can make a new listing, see which of their listing are booked (William)
* Booking module (can be accessed by customer), here customer can see all the listing, sort, search, and filter by categories (Brian)
* Payment module (accesed by customer) this is where customer can do their payment (Damar)
* Rating module (accesed by customer) this is where customer can rate hotels (Zakiy)
* Authentication module ( this is where login, register and stuff) (Nala)
* User profile module ( accesed by customer) this is where user can customize their profile. (Izzy)

## **User roles and their descriptions**

### 1. Guests
Guests are users who seek accommodations on the platform. Their primary functions include:
- **Browse Listings**: Search for and view properties available for rent.
- **Make Bookings**: Reserve accommodations based on availability and preferences.
- **Leave Reviews**: Provide feedback and rate their stay to assist future guests in their decision-making.
- **Manage Profile**: Update personal information.
### 2. Hosts
Hosts are property owners who list their accommodations on the platform. Their key responsibilities include:
- **Add Properties**: Create new listings with detailed descriptions and photos of their accommodations.
- **Manage Listings**: Edit, update, and delete their property listings as necessary.
- **Respond to Inquiries**: Communicate with potential guests regarding property details, availability, and bookings.
- **View Bookings**: Monitor reservations made by guests and manage the booking calendar.

## **Integration with the web service to connect to the web application created in the midterm project**

Integration with Web Service
This application integrates a Flutter mobile frontend with a Django backend web application created during the midterm project. The integration is achieved through a RESTful web service, allowing the mobile app to fetch, display, and send data dynamically.

**Integration Details**

1. Backend:

* The Django backend serves as the web service, exposing REST API endpoints using the Django REST Framework (DRF).
* Data is exchanged in JSON format, with endpoints handling HTTP methods such as:
  * GET: To fetch data.
  * POST: To create new records.
  * PUT: To update existing records.
  * DELETE: To remove records.

2. Frontend:

* The Flutter mobile application acts as the client, consuming the REST API provided by the backend.
* The http package is used in Flutter to send HTTP requests and handle responses from the backend.

3. Key Features:

* Fetching Data: The app retrieves JSON data using the GET method and maps it to Flutter model classes.
* Sending Data: The app converts data into JSON format using toJson methods for POST and PUT requests.
* Dynamic Display: Data fetched from the backend is parsed and displayed using widgets like ListView and FutureBuilder.

**Profile Feature**

***1. Viewing User Profiles***

***Feature***: Display a list of user profiles with details such as username, email, first name, last name, and profile picture.

***API Endpoint***: ```GET /users/profiles/```

***Description***: This endpoint retrieves a list of all user profiles. The ProfilePage in viewprofile.dart fetches this data using the fetchProfiles method and displays it in a list.

***2. Editing User Profiles***
   
***Feature***: Allow users to edit their profile information, including username, email, first name, last name, and profile picture. For the profile picutre, the user will be given a few choiches of predetermined images and they can choose which one they want to pick as their profile picture.

***API Endpoint***: ```POST /users/update_profile_flutter/``` 

***Description***: This endpoint updates the user's profile information. The EditProfilePage in ```editprofile.dart``` sends a POST request with the updated profile data to this endpoint. Upon successful update, the profile information is saved, and the user is notified.

**Authentication**

***1. Login*** 
***Feature***: Display a login form for existing users to enter their username and password to access their accounts.

***API Endpoint***: POST /auth/login/

***Description***: This endpoint handles user login. The LoginPage in login.dart sends a POST request with the user's credentials (username and password) to this endpoint.

***2. Register*** 
***Feature***: Display a registration form for new users to create an account.

***API Endpoint***: POST /auth/register/

***Description***: This endpoint allows users to create a new account by providing their username, password, and role. The registration process validates the inputs, including password confirmation and role selection. Upon successful registration, the user is notified and redirected to the login page.

 
**Rating Feature**

### 1. Viewing Rating for a Property

**Feature**: Display a list of ratings and reviews including who wrote the review and when it was posted.

**API Endpoint**: `GET /api/hotels/{hotel_id}`

**Description**: This endpoint retrieves the details of a specific hotel, including the rating. The `HotelDetailPage` in `hotel_detail_page.dart` fetches the data using the `fetchHotelDetail` method.

---

### 2. Adding Rating for a Property

**API Endpoint**: `POST /api/hotels/{hotel_id}/add-rating/`

**Feature**: Add a rating and review to a property.

**Description**: This endpoint submits a rating to a property. The `addrating` page in `addrating.dart` will send a POST request with the review and rating data to that endpoint. If successful, the rating and review will appear in the `HotelDetailPage`, and the average rating in the `HomePage` of that hotel will update.


**Role Login Feature**
### 1. Users Register as a Guest or Host

**API Endpoint**: `POST /auth/register/`

**Feature**: When creating an account, the user will either register as a guest or a host

**Description**: This registration page allows users to create an account with the choice of two roles: Guest or Host. The user provides their username, password, and confirms the password. Upon submission, the user is required to select one of the roles from a dropdown list. If the selected role is not provided, the user will be prompted to choose a role. Once the form is completed and submitted, the API service sends the registration request to the backend. Upon successful registration, the user is navigated to the login page. If registration fails, an error message is displayed.

**Host Dashboard Feature**

### 1. Add Property
**API Endpoint**: `POST /add_property/`

**Feature**: Add a Property onto the Host Dashboard

**Description**: This endpoint allows hosts to add a new property to their dashboard. The AddPropertyPage in addproperty.dart sends a POST request containing property details (such as hotel name, category, price, address, and amenities) to this endpoint. Upon successful submission, the new property will appear on the host dashboard, and users can view it in relevant listings. If the submission fails, an error message is displayed to the host.

### 2. Delete Property
**API Endpoint**: `POST /delete/{property-id}/`

**Feature**: Delete a Property on the Host Dashboard

**Description**: This endpoint deletes a property from the host dashboard. The HostDashboardPage in host.dart sends a POST request to delete a property by its unique property_id. When the delete button is pressed, a confirmation dialog appears. If confirmed, the property is removed from the database, and the list of properties refreshes. A success or error message is displayed based on the outcome.

### 3. Edit Property
**API Endpoint**: `POST /edit_property_api/`

**Feature**: Edit a selected Property on the Host Dashboard
**Description**: This endpoint updates the details of an existing property. The EditPropertyPage in editproperty.dart sends a POST request containing the updated property data (hotel name, category, price, address, and amenities) to this endpoint. The property is identified by its unique property_id. If the update is successful, the modified property details will reflect on the host dashboard and listing pages. If the property is not found or unauthorized, an error message is shown.