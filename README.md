# rePlace: /r/place project reloaded

The goal of this project is to qualify the collaboration between users in Reddit's social experiment "Place". In this experiment, users were allowed to choose the color of a pixel on a 1000x1000 canvas every 5 minutes. A timelapse can be seen here :

[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/XnRCZK3KjUY/0.jpg)](http://www.youtube.com/watch?v=XnRCZK3KjUY)


## The data and its features
The [full original dataset](https://www.reddit.com/r/redditdata/comments/6640ru/place_datasets_april_fools_2017/) contains all tile placements for the 72 hours duration of Place with the following information for each click :

	- timestamp
	- hash of the user
	- x and y coordinates on the canvas
	- color

The collaboration between users was measured by the **local agreement** : for each click, it is the ratio between the number of tiles with the same color over the number of already occupied tiles in the 8 ones around it.

From this, the *previous agreement* measure was also computed for each click : it is the mean of the local agreement on the 9 tiles below and around the tile being clicked on.

The user features extracted are :

- the mean local agreement,
- the number of collaborators (distinct users who clicked on tiles surrounding the ones the current user clicked) divided by the number of clicks,
- the average time between clicks,
- the median distance between clicks,
- the number of clicks.

All of these and their relation to the local agreement can be found in the notebook `data_processing.ipynb`.


## Methodology

The aim is to design a model to predict the local agreement of the next click of a user, knowing which tile he is clicking on and his previous actions.

As they were considered to be the most representative and relevant part of the data, only the final 2 millions interactions were kept from the original set, in an effort to have reasonable computability.

The full set was then split into training, validation and test as such : only the last click for each user was kept in the test set, the one before that in the validation set, and all the rest in the training set.

All the models (except the linear regression) are trained by minimizing the MSE loss of the prediction over batches with a Stochastic Gradient Descent optimizer.


## Models
### 1. Feature-based models
The features described above were computed for all clicks starting from the third one of each user. These models and all their details can be seen in the notebook `embedded_models.ipynb`.
#### 1.1 Linear Regression
The first simple choice for a predictive model is the linear regression.
Between all the possible combinations of 1 to all 6 of the features, the best one is the one with all the features. It performs slightly better than the baseline consisting of simply returning the average local agreement of the user as a prediction for the agreement of his next click.
#### 1.2 Neural network
To see if there is some non-linear relation between those features and the local agreement, we train a basic neural network, with only one hidden fully connected layer of size 12 and a sigmoid activation function, which takes the features as input and outputs one value as the predicted agreement. The best achievable performance with this model is very similar to the linear regression.


### 2. Embedding-based models
The first two models are implemented in the notebook `feature_models.ipynb` and the last one in `zone_model.ipynb`.
#### 2.1 Simple user embedding
Only one scalar per user, as an embedding vector of size 1. Simply return this as a prediction for the user.
As expected these converge to the mean local agreement of each user, thus the model performs like the baseline.

#### 2.2 User-user collaboration
Now each user is represented by a vector of size 10, and also a bias (size 1). To compute the prediction for a given user, we add his bias to the dot product of his embedding and the one of the user who previously clicked on the tile.
This model was designed to capture users interaction and collaboration, but surprisingly, it performed very poorly compared to the baseline and simpler models.

An other model was designed to try to capture user-user collaboration by concatenating the embedding vectors of the user and the previous one into a vector of size 20, which is then fed to a neural network with two hidden layers of size 10 and 5 and an output of size 1, which is the prediction.
While this achieves better performance than the previous model, it is still worse than all the other ones.

#### 2.3 Space-user collaboration
The disappointing performance of the models trying to capture interactions between users brings us to another outlook on the problem. Can interactions between users and some specific zones in the canvas be capture by embeddings ? 

To answer this question, we splitted the canvas in a 20x20 grid and each of the 400 zones is represented by a vector of size 10, like the users.
The prediction of the new model is the dot product of the user vector with the embedding of the zone he is clicking on.

Although the performance of this model is moderate, without any improvement over the simple user scalar model, the interpretation of its parameters (the embeddings) is more relevant here.

Indeed, after training the model, the dot product of each user with each zone is computed. From this, users can be ranked in each zone by their level of "collaboration". To see this more clearly, let's consider the patch covering the center of the US flag in the middle of the canvas.
The activity of the top 10'000 users can be seen ![here](https://github.com/JRappaz/rePlace/tree/master/figures/usa_flag_top_10k.pdf).

Whereas the activity of the tail 10'000 users can be seen ![here](https://github.com/JRappaz/rePlace/tree/master/figures/usa_flag_tail_10k.pdf)
.



## Results
| Model                         | Test RMSE    |
| -------------                 |:-------------:|
| Baseline                      | 0.31439 |
| Linear Regression             | 0.28742 |
| Neural Network with features  | **0.28701** |
| User scalar                   | 0.32177 |
| User-previous dot             | 0.42435 |
| User-previous concat   		  | 0.33172 |
| User-zone dot   		         | 0.32442 |


