from flask import Flask, jsonify, request
import pandas as pd
import pickle

app = Flask(__name__)

# Step 1: Load the data (ratings.csv, combined_movies.csv, and users.csv)
ratings_file_path = 'ratings.csv'  # Update this path with your Google Drive path
movies_file_path = 'combined_movies.csv'  # Update this path with your Google Drive path
users_file_path = 'users.csv'  # Update this path with your Google Drive path

ratings = pd.read_csv(ratings_file_path)
movies = pd.read_csv(movies_file_path)
users = pd.read_csv(users_file_path)

# Step 2: Load the pre-trained SVD model from the pickle file
with open('svd_recommender_model.pkl', 'rb') as f:
    svd_model = pickle.load(f)

# Convert users data to a dictionary for quick lookup of password and userId
users_dict = users.set_index('username')[['password', 'userId']].to_dict(orient='index')

# Login endpoint
@app.route('/login', methods=['POST'])
def login():
    """
    Endpoint to check if the username and password provided are correct.
    :return: Success with userId or failure response in JSON format.
    """
    data = request.json
    username = data.get('username')
    password = data.get('password')

    if username in users_dict and users_dict[username]['password'] == password:
        user_id = users_dict[username]['userId']
        return jsonify({"status": 200, "userId": user_id, "message": "Success", "movies": []}), 200
    else:
        return jsonify({"status": 400, "message": "Username or Password Not Found", "movies": []}), 400

# Function to recommend top-N movies for a specific user
def get_recommendations(user_id, model, n=10):
    all_movie_ids = ratings['movieId'].unique()
    rated_movies = ratings[ratings['userId'] == user_id]['movieId'].values
    unrated_movies = [movie for movie in all_movie_ids if movie not in rated_movies]

    predictions = [model.predict(user_id, movie_id) for movie_id in unrated_movies]
    top_predictions = sorted(predictions, key=lambda x: x.est, reverse=True)
    top_movie_ids = [pred.iid for pred in top_predictions[:n]]

    return top_movie_ids

# Endpoint to fetch movies a user has rated
@app.route('/user/<int:user_id>/movies', methods=['GET'])
def user_rated_movies(user_id):
    """
    Endpoint to return the movies the user has rated.
    """
    try:
        # Get the movies the user has already rated
        user_rated_movies = ratings[ratings['userId'] == user_id]

        # Merge with movie details
        user_movies = user_rated_movies.merge(movies, on='movieId')

        # Replace NaN values with None
        user_movies = user_movies.where(pd.notnull(user_movies), None)

        # Convert the movies data to a list of dicts
        user_movies_list = user_movies[['movieId', 'title', 'genres', 'original_title', 'overview', 'poster_path', 'backdrop_path']].to_dict(orient='records')

        # Return the response in JSON format
        return jsonify({
            "status": 200,
            "userId": user_id,
            "message": "Success",
            "movies": user_movies_list
        }), 200

    except Exception as e:
        return jsonify({"status": 400, "message": str(e), "movies": []}), 400

# Endpoint to provide movie recommendations for a specific user
@app.route('/user/<int:user_id>/recommendations', methods=['GET'])
def user_recommendations(user_id):
    """
    Endpoint to return movie recommendations for a user based on user_id only.
    """
    try:
        # Get top-N movie recommendations for the user
        top_movie_ids = get_recommendations(user_id, svd_model, n=10)

        # Merge to get the movie titles and other details
        recommended_movies = movies[movies['movieId'].isin(top_movie_ids)]

        # Replace NaN values with None (which corresponds to null in JSON)
        recommended_movies = recommended_movies.where(pd.notnull(recommended_movies), None)

        # Convert recommended movies to a list of dicts
        recommended_movies_list = recommended_movies[['movieId', 'title', 'genres', 'original_title', 'overview', 'poster_path', 'backdrop_path']].to_dict(orient='records')

        # Return the recommended movies in JSON format
        return jsonify({
            "status": 200,
            "userId": user_id,
            "message": "Success",
            "movies": recommended_movies_list
        }), 200

    except Exception as e:
        return jsonify({"status": 400, "message": str(e), "movies": []}), 400

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True)
