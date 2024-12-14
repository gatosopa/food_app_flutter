# Foodie

This project is a Flask-based backend API that integrates with Firebase and Spoonacular API to provide recipe recommendations, manage user ingredients, and handle food-related functionality. The application can analyze fridge images, suggest recipes, and store user preferences in a database. This app is loaded in a flutter app.

## Features

### Core Functionalities

1. **Image Upload and Analysis**:
   - Users can upload an image (e.g., of fridge contents).
   - The image is analyzed using OpenAI's API to extract a list of ingredients.

2. **Recipe Recommendation**:
   - Recommends recipes based on provided ingredients.
   - Supports searching recipes by keyword or random daily recommendations.

3. **User Management**:
   - Uses Firebase Firestore to manage user profiles, including stored ingredients and favorite recipes.

4. **Ingredient Management**:
   - Retrieve, update, and save a user's fridge ingredients.

5. **Favorites**:
   - Users can save favorite recipes and retrieve them later.

6. **Nutritional and Cooking Information**:
   - Retrieves nutritional details, cooking steps, and other metadata for recipes.

---

## Installation

### Prerequisites
- Python 3.8+
- Flask
- Firebase Admin SDK
- Spoonacular API Key
- OpenAI API Key

### Setup Steps

1. **Clone the Repository**:

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

5. **Run the Application**:
   ```bash
   python server.py
   ```

   The app will start running on `http://localhost:5000`.

---

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

---

## Code Structure

- `server.py`: The main Flask application with route definitions.
- `uploads/`: Directory to store uploaded images.

