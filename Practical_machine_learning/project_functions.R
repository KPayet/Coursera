# a simple function to tune the SVM hyperparameters
# The e1071 library has a tune function, but it uses only one core
# I am writing a simple function so that I can use multiple cores
tune_SVM <- function(trainData, gammas = 10^(-4:0), costs = 10^(-3:1)) {
    # the tuning will be done by using 10-fold cross validation
    # the data is expected to be a list with 2 elements: inputs and targets
    
    library(caret)
    library(foreach)
    library(parallel)
    library(doParallel)
    library(e1071)
    
    numCores <- detectCores()  
    cl <- makeCluster(numCores)  
    registerDoParallel(cl)
    
    allData <- cbind(trainData$inputs, trainData$targets)
    
    # shuffle dataset first so that we can unbiases subsamples
    
    allData <- allData[sample(1:nrow(allData), nrow(allData), F),]
    
    folds <- createFolds(allData[,ncol(allData)], k = 10, list = TRUE)
    
    params <- data.frame(error = numeric(0), gamma = numeric(0), cost = numeric(0))
    
    for(gamma in gammas) {
        
        for(cost in costs) {
            
            results <- foreach(i=1:10) %do% {
                library(e1071)
                library(caret)
                
                train <- list(inputs = allData[-folds[[i]],-ncol(allData)], 
                              targets = allData[-folds[[i]],ncol(allData)])
                test <- list(inputs = allData[folds[[i]],-ncol(allData)], 
                             targets = allData[folds[[i]],ncol(allData)])
                
                preObj <- preProcess(train$inputs, method = c("center", "scale"))
                train$inputs <- predict(preObj, train$inputs)
                test$inputs <- predict(preObj, test$inputs)
                
                model <- svm(x = train$inputs,
                             y = train$targets,
                             scale = FALSE,
                             type = "C-classification", 
                             kernel = "radial", 
                             gamma = gamma, cost = cost)
                
                prediction <- predict(model, train$inputs)
                cfm <- table(prediction, train$targets)
                print(cfm)
                result <- 1 - sum(diag(cfm))/sum(cfm)
                print(result)
                result
            } # end foreach
            
            avg_error <- mean(sapply(results, FUN = function(x){x[1]}))
            
            strff <- paste("gamma = ", gamma, " cost = ", cost, " error = ", avg_error)
            
            print(strff)
            params <- rbind(params, list(error = avg_error, gamma = gamma, cost = cost))

        } # end loop on costs
    } # end loop on gammas
    
    minInd <- which.min(params$error)
    print(params[minInd,])
    
    stopCluster(cl)  
}