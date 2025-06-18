# NewsFeedApp

Welcome to the NewsFeed app! This project fetches and displays data from the newsapi.org API, showcasing recent news across business, entertainment, general, health, science, sports, and technology categories on the home screen.

## Features

### 1. Recent News Display
* **Automatic Data Fetching**: On launch, the app automatically loads recent news, displaying the title, image, and description.
* **Viewing Selected Article**: Users can view selected articles in detail and read the complete content.

### 2. Different Category Selection
* **User Control**: Users can select from categories including business, entertainment, general, health, science, sports, and technology. The app seamlessly loads the respective news for each category.

### 3. Saving Articles for Later
* **User Control**: Users can save articles for later reading and delete them once finished.

## Caching Mechanism
* The app uses `URLCache` for caching both news API requests and image URL requests.
* A custom `CacheAsyncImage` view is implemented to extend the functionality of `AsyncImage`, allowing for efficient image caching based on URL.

## Local Storage Mechanism
* The app uses `SwiftData` for saving articles for later reading. Users have the option to delete articles after reading them.

## Unit Tests and Test Plan
* The app uses the latest `Swift Testing` framework for unit testing. There is a detailed test plan in the project for unit test execution.

## Project Setup

### Enabling the API Key

To set up the app in debug mode:

1. **Create .xcconfig files:**
   ```
   In Xcode, go to File > New > File...
   Select Configuration Settings File
   ```

2. **Define key-value pairs:**
   ```
   NEWS_API_KEY=<ADD_YOUR_API_KEY>
   ```

3. **Link .xcconfig files to build configurations:**
   ```
   In the Project Navigator -> Go to the Info tab -> Under Configurations -> select the corresponding .xcconfig file
   ```

4. **Accessing values in code:**
   ```
   To access the value in .xcconfig file through the Info.plist
   In Info.plist add key as "NEWS_API_KEY" and its value as "$(NEWS_API_KEY)"
   ```

### Alternate API Key Access
Although not recommended, for the sake of simplicity, the API key is intentionally left in the code. It's present in the APIConstants enum—uncomment it and use it instead of the variable "key".

## Further Enhancements

### Dynamic API Key Management
Currently, the API key is managed via an .xcconfig file locally. In the future, it can be deployed on a remote server and accessed by making calls to the backend server.

