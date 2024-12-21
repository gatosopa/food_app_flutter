# Foodie App
![landing](https://github.com/user-attachments/assets/89116540-30ce-49b4-9815-b9dbb31171b9)

The Foodie App is an AI-powered application designed to identify ingredients from fridge pictures and recommend recipes based on those ingredients. The app aims to make cooking easier and more accessible by leveraging advanced machine learning models and user-friendly features.

## Features

### Core Functionalities

1. **Image Upload and Analysis**:

![image](https://github.com/user-attachments/assets/89da827e-f2d2-4cc6-af01-64e68d4aab42)

   - Users can upload an image (e.g., of fridge contents).
   - The image is analyzed using OpenAI's API to extract a list of ingredients.

3. **Recipe Recommendation**:

![image](https://github.com/user-attachments/assets/8fae9efb-b461-4b01-b8dd-d0e13f3f3bc9)

   - Recommends recipes based on provided ingredients.
   - Supports searching recipes by keyword or random daily recommendations.

3. **Recipe Search**:

![image](https://github.com/user-attachments/assets/76b35f2a-f336-440b-b90c-891ce4eb2d87)

   - Allows users to search for recipes using keywords.
   - Returns results with relevant nutritional details, steps, and cooking times.

4. **User Management**:

![image](https://github.com/user-attachments/assets/0ca1e7f1-b0fb-4045-a11d-421a69731126)

   - Uses Firebase Firestore to manage user profiles, including stored ingredients and favorite recipes.

5. **Ingredient Management**:

![image](https://github.com/user-attachments/assets/bfa8ba22-4e0f-4b46-afa6-4aa27053cdc9)

   - Retrieve, update, and save a user's fridge ingredients.

6. **Preferences for Price, Health, and Lifestyle**:

![image](https://github.com/user-attachments/assets/dcfe232f-13e0-4635-a41b-a2794dda758e)

   - Allows users to customize their preferences for recipe recommendations based on price, dietary health considerations, and lifestyle choices.

7. **Favorites**:

![image](https://github.com/user-attachments/assets/9aac97ea-bf45-46c0-826b-a085ce8bb839)

   - Users can save favorite recipes and retrieve them later.

8. **Nutritional and Cooking Information**:

![image](https://github.com/user-attachments/assets/ac9d03c7-ec58-4d51-98fc-b5dcf5719faf)

   - Retrieves nutritional details, cooking steps, and other metadata for recipes.

## Technologies Used

- **Frontend**: Flutter
- **Backend**: Flask
- **Firebase Integration**: Firebase Firestore
- **APIs**:
  - Spoonacular API
  - OpenAI API

### Flutter Libraries

The project makes use of the following Flutter libraries:

- `cupertino_icons` (iOS-style icons)
- `gal` (gallery integration)
- `camera` (camera functionalities)
- `image_picker` (image selection)
- `dio` (HTTP client for network requests)
- `flutter_bloc` (state management)
- `get` (dependency injection and state management)
- `carousel_slider` (image slider)
- `iconsax` (icon library)
- `page_transition` (page transitions)
- `animated_bottom_navigation_bar` (animated bottom navigation)
- `firebase_core` (Firebase core integration)
- `firebase_auth` (Firebase authentication)
- `cached_network_image` (efficient image caching)
- `cloud_firestore` (Firebase Firestore integration)
- `shared_preferences` (local storage)
- `firebase_storage` (Firebase cloud storage)
- `ionicons` (icon library)
- `auto_size_text` (dynamic text resizing)

## Architecture

The app follows a **Feature-First Architecture** combined with the **MVVM (Model-View-ViewModel)** pattern for scalable and maintainable state management. Key features include:

- Modular design for feature-specific code organization.
- Separation of UI, business logic, and data layers.

## Installation

### Prerequisites

- Python 3.8+
- Flask
- Firebase Admin SDK
- Spoonacular API Key
- OpenAI API Key
- Flutter SDK installed on your machine.
- Compatible IDE (e.g., Android Studio or Visual Studio Code).

### Setup Steps

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   ```
2. **Firebase Configuration**:
   - Download your Firebase Admin SDK JSON file and place it in the root directory.
   - Update the `cred` variable in the code with the file path.

3. **Set Environment Variables**:
   - Replace the placeholders in the code with your API keys.
     - `RECIPE_API_KEY` (Spoonacular API)
     - `OPENAI_API_KEY`

4. **Create Upload Folder**:
   ```bash
   mkdir uploads
   ```

5. **Run the Backend Application**:
   ```bash
   python server.py
   ```

6. **Run the Frontend Application**:
   ```bash
   flutter pub get
   flutter run
   ```

The app will start running on `http://localhost:5000` for the backend and the designated port for the Flutter app.

## API Endpoints

### 1. **File Upload**
   - **Endpoint**: `POST /upload`
   - **Description**: Upload an image and identify ingredients using OpenAI's API.
   - **Response**:
     ```json
     {
       "ingredients": ["egg", "milk", "cheese"]
     }
     ```

### 2. **Submit Ingredients**
   - **Endpoint**: `POST /submit_json`
   - **Description**: Submit ingredients to Spoonacular API in JSON format and get recipes.
   - **Request**:
     ```json
     {
       "user_id": "user123",
       "ingredients": ["tomato", "onion", "cheese"]
     }
     ```
   - **Response**:
     ```json
     [
       {
         "id": 12345,
         "title": "Tomato Soup",
         "cuisine_type": "Italian",
         "steps": ["1. Chop tomatoes", "2. Boil in water"],
         "cooking_time": 30
       }
     ]
     ```

### 3. **Get Ingredients**
   - **Endpoint**: `GET /get_ingredients/<user_id>`
   - **Description**: Retrieve the user's fridge ingredients.
   - **Response**:
     ```json
     {
       "user_id": "user123",
       "ingredients": ["egg", "milk", "cheese"]
     }
     ```

### 4. **Update Ingredients**
   - **Endpoint**: `POST /update_ingredients`
   - **Description**: Update a user's fridge ingredients.
   - **Request**:
     ```json
     {
       "user_id": "user123",
       "ingredients": ["butter", "bread", "jam"]
     }
     ```
   - **Response**:
     ```json
     {
       "message": "Ingredients list updated successfully"
     }
     ```

### 5. **Get Favorite Recipes**
   - **Endpoint**: `GET /get_fav_recipes/<user_id>`
   - **Description**: Retrieve a user's favorite recipes.

### 6. **Daily Recipe Recommendations**
   - **Endpoint**: `POST /get_daily_recipes`
   - **Description**: Fetch random recipes based on user preferences.
   - **Request**:
     ```json
     {
       "include_tags": ["vegan", "gluten-free"],
       "number": 3
     }
     ```

### 7. **Search Recipes by Keyword**
   - **Endpoint**: `POST /recipes/search`
   - **Description**: Search for recipes by a keyword.
   - **Request**:
     ```json
     {
       "keyword": "pasta",
       "number": 2
     }
     ```

## Code Structure

- `server.py`: The main Flask application with route definitions.
- `uploads/`: Directory to store uploaded images.

## Project Directory

```
└── 📁lib
    └── 📁src
        └── 📁core
            └── constants.dart
            └── 📁containers
                └── section_heading.dart
            └── exceptions
            └── havetochange.dart
            └── root_page.dart
            └── 📁shapes
                └── circular_container.dart
                └── rounded_image.dart
            └── themes
            └── 📁utils
                └── favorite_notifier.dart
                └── food_notifier.dart
                └── food_storage.dart
                └── get_daily_recipes.dart
                └── parser.dart
                └── profile_notifier.dart
            └── 📁widgets
                └── bottom_navigation_bar.dart
                └── food_card.dart
        └── 📁features
            └── 📁camera
                └── 📁data
                    └── 📁models
                    └── 📁repositories
                        └── camera_repository.dart
                └── 📁presentation
                    └── 📁view
                        └── available_ingredient_page.dart
                        └── camera_page.dart
                        └── camera_view.dart
                        └── editable_page.dart
                        └── image_popup.dart
                        └── needed_ingredient_page.dart
                        └── 📁widgets
                            └── ingredient_list.dart
                            └── recipe_card.dart
                    └── 📁viewmodel
                        └── camera_cubit.dart
                        └── camera_state.dart
            └── 📁favorites
                └── favorites_page.dart
                └── health_page.dart
                └── lifestyle_page.dart
                └── my_preferences_page.dart
                └── price_page.dart
                └── 📁widgets
                    └── my_preferences.dart
            └── 📁home
                └── 📁controllers
                    └── controller.dart
                └── home_page.dart
                └── recipe_view_all_page.dart
                └── search_page.dart
                └── 📁widgets
                    └── categories.dart
                    └── food_slider.dart
            └── 📁inventory
                └── inventory_page.dart
                └── my_fridge.dart
                └── 📁widgets
                    └── inventory_ingredient_list.dart
            └── 📁login
                └── auth_page.dart
                └── 📁components
                    └── my_button.dart
                    └── my_textfield.dart
                    └── square_tile.dart
                └── forgotPassword_page.dart
                └── login_page.dart
                └── loginOrRegister_page.dart
                └── register_page.dart
            └── 📁onboarding
                └── login_signup.dart
                └── onboarding_page.dart
            └── 📁profile
                └── edit_profile_page.dart
                └── profile_page.dart
            └── 📁recipe
                └── detail_page.dart
                └── recipe_page.dart
                └── 📁widgets
                    └── detail_ingredients.dart
                    └── detail_nutrition.dart
                    └── expanded_widget.dart
                    └── recipe_appbar.dart
        └── 📁models
            └── cuisine.dart
            └── food.dart
            └── ingredients.dart
            └── recipe_model.dart
    └── main.dart
```
