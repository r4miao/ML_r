#install.packages("neuralnet")
#install.packages("randomForest")
#install.packages("iml")
library(neuralnet)
library(janitor)
library(randomForest)
library(iml)
# Simulate data
set.seed(123)
data <- data.frame(
  age = rnorm(100, mean = 35, sd = 10),               # Numeric variable
  gender = sample(c(0, 1), 100, replace = TRUE),      # Dummy variable
  education = sample(
    c("High School", "Bachelor's", "Master's"), 
    100, 
    replace = TRUE
  ),  # Multi-category variable
  outcome = sample(c(0, 1), 100, replace = TRUE)      # Binary target
)

head(data)
# One-hot encode the 'education' variable
education_one_hot <- model.matrix(~ education - 1, data)

# Scale numeric variable 'age'
data$age <- scale(data$age)

# Combine preprocessed data into a single dataframe
data_processed <- cbind(data[c("age", "gender", "outcome")], education_one_hot)

# Clean the column names using janitor
data_processed <- as.data.frame(clean_names(data_processed))
names(data_processed)

# Define the formula for the neural network
formula_nn <- as.formula(
  "outcome ~ age + gender + education_high_school + 
  education_bachelors + education_masters"
)


# Fit the neural network model
nn_model <- neuralnet(
  formula_nn,
  data = data_processed,
  hidden = c(5, 3),          # Two hidden layers with 5 and 3 neurons
  linear.output = FALSE,     # FALSE for binary classification (sigmoid)
  stepmax = 1e6              # Maximum number of steps for training
)

plot(nn_model)

# Predictions
predictions <- compute(nn_model, data_processed[, -3])  # Exclude 'outcome'
predicted_values <- predictions$net.result
predicted_classes <- ifelse(predicted_values > 0.5, 1, 0)

# Compare predictions with actual values
results <- data.frame(
  Actual = data_processed$outcome,
  Predicted = predicted_classes
)

# Accuracy
accuracy <- mean(results$Actual == results$Predicted)
print(paste("Accuracy:", round(accuracy * 100, 2), "%"))


# Create a predictor object for the neural network model
predictor_nn <- Predictor$new(
  model = nn_model,
  data = data_processed[, -3],  # Exclude the outcome column
  y = data_processed$outcome
)

# Compute Shapley values
shapley_nn <- Shapley$new(predictor_nn, x.interest = data_processed[1, -3])

# Plot Shapley values
plot(shapley_nn)




############################################################
# Fit the Random Forest model
# Convert the outcome variable to a factor for classification
data_processed$outcome <- as.factor(data_processed$outcome)

rf_model <- randomForest(
  outcome ~ age + gender + 
    education_high_school + 
    education_bachelors + education_masters,
  data = data_processed,
  ntree = 100,  # Number of trees
  mtry = 2,     # Number of variables randomly sampled as candidates at each split
  importance = TRUE
)

# Predictions
rf_predictions <- predict(rf_model, data_processed)

# Compare predictions with actual values
rf_results <- data.frame(
  Actual = data_processed$outcome,
  Predicted = rf_predictions
)

# Accuracy
rf_accuracy <- mean(rf_results$Actual == rf_results$Predicted)
print(paste("Random Forest Accuracy:", round(rf_accuracy * 100, 2), "%"))

# Optional: View variable importance
importance(rf_model)
varImpPlot(rf_model)


