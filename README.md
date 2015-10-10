# rails-4-rest-api-demo
RESTful API, secured with basic authentication &amp; role-based access limitation

## Description:

### A simple Project that enables users to do the following (based on roles & privileges granted):

- CRUD for a Running activity (distance, activity venue in which this activity took place).
- CRUD for an Activity Venue (name, longitude, latitude).

### Roles & privileges:

- *admin*: can do everything
- *user*: can read all, create all, but only can update his own records.
- *guest*: has only read access