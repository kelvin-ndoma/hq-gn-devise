# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
rails g devise:controllers users -c sessions registrations

Summary of Routes from Signup to Logout:

Signup:
POST /signup

Login:
POST /login

Logout:
DELETE /logout

Change Password:
PATCH /users/passwords/change

Update User Profile:
PATCH /users
PUT /users

Delete Account:
DELETE /users

http://localhost:3000/users/passwords/reset

["example@example.com",
 "john@example.com",
 "joh@example.com",
 "kelvin@gmail.com",
 "ndoma@example.com",
 "aparajitkev@gmail.com",
 "kelvinndomamutua@gmail.com",
 "test@test.com",
 "test1@test.com",
 "john.doe@example.com"]

 /users for user profile update
 rubocop -for solving cli error
 