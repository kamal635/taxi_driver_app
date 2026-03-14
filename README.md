# Taxi Driver App

Android-based Flutter application for taxi drivers, built with a scalable architecture and background runtime support for real-time driver workflows.

## Overview

**Taxi Driver App** is a driver-facing mobile application designed to support day-to-day taxi operations such as:

- driver authentication
- online/offline availability
- real-time trip offers
- background driver mode
- location updates
- offer handling flow

The project is being built with a strong focus on maintainability, modularity, and production-ready architecture.

## Current Scope

The app currently includes the core driver runtime needed for online mode on Android:

- driver availability toggle
- native Android foreground service
- background location collection
- periodic location sync to backend
- native background offer socket runtime
- local Android notifications for incoming offers
- Flutter-side offer state management
- offer expiry handling
- resume sync with backend
- guarded accept/decline flows for expired offers

## Architecture

This project follows a modular Flutter architecture with clear separation of concerns:

- **Presentation layer**
  - Riverpod providers/controllers
  - UI state handling
  - feature-based presentation logic

- **Domain layer**
  - entities
  - repositories
  - use cases

- **Data layer**
  - remote data sources
  - local persistence
  - model mapping
  - repository implementations

### State Management
The app uses **Riverpod** for state management.

### Android Background Runtime
For Android driver mode, the app uses a **native foreground service** to handle background-critical tasks such as:

- keeping driver mode alive while the app is in background
- fetching device location periodically
- sending location updates to backend
- receiving trip offers through a native socket connection
- showing local notifications for new offers

Flutter remains responsible for:

- UI rendering
- app state
- offer presentation logic
- user actions such as accept/decline

## Key Features Implemented

### Driver Availability
- toggle online/offline state
- persist locally requested online state
- restore availability state after app restart

### Background Driver Mode
- Android foreground service integration
- notification permission handling for Android 13+
- background runtime start/stop through Flutter-to-native bridge

### Location Updates
- native Android location fetch every 15 seconds
- backend sync with token-authenticated requests
- retry/backoff handling for failed sends
- unauthorized handling with service shutdown

### Offer Runtime
- native Socket.IO-based offer listener
- driver room join flow
- native-to-Flutter payload bridge
- local offer notifications
- notification open events routed back to Flutter

### Offer Safety Handling
- pending offer expiry timer
- automatic local cleanup when offer expires
- validation before accept/decline
- backend resync on app resume
- sync after opening the app from an offer notification

## Tech Stack

- **Flutter**
- **Riverpod**
- **Kotlin (Android native layer)**
- **Android Foreground Service**
- **Socket.IO**
- **SharedPreferences**
- **Google Play Services Location**

## Project Structure

The project is organized by feature and layer.

Example high-level structure:

```text
lib/
  core/
  features/
````

## Platform Support

Current background runtime implementation is focused on:

* **Android**

## Development Notes

This project is under active development and currently prioritizes:

* stable background runtime
* clean architecture
* feature isolation
* real-time driver workflows
* production-oriented structure

## Getting Started

### Prerequisites

* Flutter SDK
* Android Studio
* Android device or emulator

### Run the project

```bash
flutter pub get
flutter run
```

## Status

The project already includes a working Android background driver mode foundation and is being extended feature by feature.

---

Built with Flutter for scalable driver operations.

```
