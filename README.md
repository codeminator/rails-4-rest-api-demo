# rails-4-rest-api-demo
RESTful API, secured with basic authentication &amp; role-based access limitation

## Description:

### A simple Project that enables users to do the following (based on roles & privileges granted):

- CRUD for an activity (name -running || swimming || racing-, distance, activity venue in which this activity took place).
- CRUD for an Activity Venue (name, longitude, latitude).

### Roles & privileges:

 - *admin*: can do everything
 - *user*: can read all, create all, but only can update his own records.
 - *guest*: has only read access


## Prerequisites:
 - Ruby version: 2.1.5
 - MySql server


## Installation:

```
 - $ git clone git@github.com:codeminator/rails-4-rest-api-demo.git
```

```
 - $ cd rails-4-rest-api-demo
```

```
 - $ bundle install
```

```
 - $ cp .env.example .env #create your own .env file to set the required environment variables.
```

```
 - rake db:create && rake db:migrate
```

```
 - rake db:seed #you will see the access token required for each user (admin || user || guest).
```

```
 - rspec --format documentation #to run test specs
```

#API End-points
Note: Any request must have these headers to be completed:


 ```
 - Accept: application/vnd.VENDOR_STRING+json;version=API_VERSION
 ```

 ```
 - X-User-Email
 ```

 ```
 - X-User-Token
 ```

###Activities

```
 - GET /activities
```

List all activities, with pagination of default page=1 & per_page=10 (maximum allowed 50) -these are configatron values that can be adjusted (check config/configatron/defaults.rb)-
 - parameters: 
     - page, per_page

```
 - GET /activity/:id
```

```
 - POST /activity, PUT /activity/:id
```

 - Parameters:
     - activity[name] #optional, defaults to :running, must be one from (running || swimming || racing), Note: you can add more types!, check: config/configatro/defaults.rb
     - activity[distance] #Mandatory
     - activity[venue_id] #Mandatory

```
 - DELETE /activity/:id
```

###Venues
```
 - GET /venues
```

 List all venues, with pagination of default page=1 & per_page=10 (maximum allowed 50)
 - parameters: 
     - page, per_page

```
 - GET /venue/:id
```

```
 - POST /venue, PUT /venue/:id
```

 - Parameters:
     - venue[name] #Mandatory
     - venue[longitude] #Mandatory (between-180, 180)
     - venue[latitude] #Mandatory (between -90, 90)

     - venue[distance] #Mandatory
     - activity[venue_id] #Mandatory

```
 - DELETE /activity/:id
```

            