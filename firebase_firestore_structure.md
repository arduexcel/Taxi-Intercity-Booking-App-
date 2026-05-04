# Firebase Firestore Database Structure for Taxi Intercity Booking App

This document outlines the proposed Firebase Firestore database structure for the Taxi Intercity Booking Application. The design aims to support three user roles: Passenger, Driver, and Admin, with efficient data retrieval and transaction management.

## 1. `users` Collection

This collection will store general user information, serving as a central point for authentication and basic profile data. Each document in this collection will represent a single user.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `uid`      | String    | User's unique ID (from Firebase Authentication) |
| `name`     | String    | User's full name |
| `phone`    | String    | User's phone number (unique) |
| `role`     | String    | User's role: `passenger`, `driver`, or `admin` |
| `balance`  | Number    | User's current balance (e.g., in IQD) |
| `createdAt`| Timestamp | Timestamp of user creation |
| `updatedAt`| Timestamp | Timestamp of last update |

## 2. `passengers` Collection

This collection will store passenger-specific details, linked to their `users` entry.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `uid`      | String    | User's unique ID (references `users.uid`) |
| `homeLocation` | GeoPoint  | Default home location for the passenger |
| `homeLocationName` | String | Name of the home location |

## 3. `drivers` Collection

This collection will store driver-specific details, linked to their `users` entry.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `uid`      | String    | User's unique ID (references `users.uid`) |
| `city`     | String    | The city the driver operates in |
| `isActive` | Boolean   | Status indicating if the driver is active and available for rides |
| `carModel` | String    | Driver's car model |
| `carPlate` | String    | Driver's car plate number |

## 4. `rides` Collection

This collection will store details for each taxi booking request. This is a critical collection for managing ride lifecycle.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `rideId`   | String    | Unique ID for the ride |
| `passengerUid` | String | UID of the passenger who requested the ride (references `users.uid`) |
| `driverUid`| String    | UID of the driver who accepted the ride (references `users.uid`). Null if not yet accepted. |
| `originCity` | String  | City where the ride originates |
| `destinationCity` | String | City where the ride is headed |
| `pickupLocation` | GeoPoint | Passenger's pickup location |
| `pickupLocationName` | String | Name of the pickup location |
| `dropoffLocation` | GeoPoint | Passenger's dropoff location |
| `dropoffLocationName` | String | Name of the dropoff location |
| `status`   | String    | Current status of the ride: `pending`, `accepted`, `cancelled_by_passenger`, `cancelled_by_driver`, `completed` |
| `fare`     | Number    | Total fare for the ride |
| `passengerDeduction` | Number | Amount deducted from passenger's balance (500 IQD) |
| `driverDeduction` | Number | Amount deducted from driver's balance (2000 IQD) |
| `requestedAt`| Timestamp | Timestamp when the ride was requested |
| `acceptedAt` | Timestamp | Timestamp when the ride was accepted by a driver |
| `completedAt`| Timestamp | Timestamp when the ride was completed |

## 5. `cities` Collection

This collection will store a list of available cities for intercity travel.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |\n| `name`     | String    | Name of the city (e.g., 'Erbil', 'Sulaymaniyah') |

## 6. `settings` Collection (Single Document)

This collection will contain a single document for application-wide settings, such as pricing.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `passengerCancellationFee` | Number | Amount deducted from passenger for cancellation (e.g., 500) |
| `driverAcceptanceFee` | Number | Amount deducted from driver for accepting a ride (e.g., 2000) |
| `baseFarePerKm` | Number | Base fare per kilometer |
| `intercitySurcharge` | Number | Additional charge for intercity travel |
