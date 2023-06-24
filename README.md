# CultureAPP

CultureAPP is a platform that helps you discover local events and purchase tickets. This is a student project, so some functionalities are mocked and may not fully represent the final product.

![CultureAPP Screenshot](assets/Mock_Presentation.jpg)

## Table of Contents
- [CultureAPP](#cultureapp)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
  - [Technologies Used](#technologies-used)
  - [Installation](#installation)
  - [Database Setup](#database-setup)
  - [API Server Setup](#api-server-setup)
  - [App Configuration](#app-configuration)

## About

CultureAPP is designed to connect you with local events and facilitate ticket purchase. It's currently a student project in development and as such, some features may be in their initial stages or mocked for demonstration purposes.

## Technologies Used

This project is developed using the following technologies:

* [Flutter 3.10.2](https://flutter.dev)
* [Node.js v18.12.1](https://nodejs.org)

## Installation

To run CultureAPP on your local machine, you'll need to have Node.js, Flutter, and MongoDB installed. Follow the setup instructions below to get started.

## Database Setup

Firstly, start your local MongoDB Database.

## API Server Setup

1. Navigate to the server directory within the project.

2. Create a `.env` file and include the following parameters:
    ```
    PORT=5000
    MONGODB_URI=mongodb://localhost:27017/culture_app
    ```
    The API Server will run on the PORT specified in the .env file. The MONGODB_URI should match your MongoDB configuration.

3. Install the required dependencies and start the server. Please ensure that your MongoDB Database is running beforehand:
    ```
    npm install
    npm start
    ```

## App Configuration

1. Install Flutter and a phone emulator of your choice (for example, Android Studio).

2. In the root directory of the project, create a `.env` file with the following content:
    ```
    API_BASE_URL=http://localhost:5000
    ```
    The `API_BASE_URL` should be the URL of your API Server, as defined in the server's `.env` file.
