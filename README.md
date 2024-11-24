## **List of group member names**
Made Izzy Prema Darma <br>
Damar Aryaputra Rahman <br> 
Serafina Nala Tri Setiawan <br>
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


