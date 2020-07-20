# RoomListDemo
Sample for MVVM, Database CRUD Operations on a seperate thread.


# List Utility 
The aim of the assignment is to make a simple two-page application which has a very basic functionality of showing a list of items retrieved from a REST API endpoint. The documentation of the REST API and how to use the endpoints can be found here https://documenter.getpostman.com/view/305987/SzYbxcVM 
Please go through the documentation carefully and understand because that is essential for making the app. 
Page 1: 
The first page should make a GET request to v1/test/roomsList and show the returned details in form of a scrollable list. Please keep in mind the performance of the page as the list can be a bit long (upto 100 elements) 
The data to be shown in each list item should be taken from the “data” array present in the JSON response. The text on the list items should be in this format 
Org Name – Property Name – Room Name 
For example, for the below data, it should be 
mxXbWx5B3I - PG6IJDwyHg - 5IGoaKsF9k 
g5NJ23nmlu - rtiGtP6LkH - m8LjTgDpYm 
. . . 
Upon clicking on any element of the list, the user should be taken to the second screen where the lock details need to be fetched and shown next. 
Page 2: 
The second page should make a request to v1/test/lockDetails by supplying the parameter room id corresponding to the element clicked on the first page. This will give in response the lock name, lock MAC address and lock description which should be displayed in the second page in a text format simply one below another. The lock description should be shown in a dynamically sized cell with height not exceeding 4 lines. In case it exceeds 4 lines, only part of it should be shown ending it with ellipsis. 
The following features need to be implemented on top of this for overall quality of the application: 
• Caching the API response and showing that incase of no internet connectivity. While doing this, a toast also should be shown indicating internet is unavailable. Depending on your interest, you can implement caching on either only page 1 or both pages 
• Pull to refresh functionality needs to be implemented on Page 1 
• The app should work in all device sizes correctly 
You will be evaluated partially also. Your app and code should be coded as if it were being done for a professionally done scalable application. It should be very clean and compact. 
If you have any doubts regarding this, do let me know at the earliest 
