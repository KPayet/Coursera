# a simple function to tune the SVM hyperparameters
# The e1071 library has a tune function, but it uses only one core
# I am writing a simple function so that I can use multiple cores
tune_SVM <- function(trainData, gammas = 10^(-1:0), costs = 10^(-2:2), cluster = NULL, kcl = T) {
    # the tuning will be done by using 10-fold cross validation
    # the data is expected to be a list with 2 elements: inputs and targets
    
    library(caret)
    library(foreach)
    library(parallel)
    library(doParallel)
    library(e1071)
    
    numCores <- detectCores()
    if(is.null(cluster)){
        cl <- makeCluster(numCores)  
        registerDoParallel(cl, cores = numCores)
    }
    else {
        cl <- cluster
        registerDoParallel(cl, cores = numCores)
    }
        
    
    allData <- cbind(trainData$inputs, trainData$targets)
    
    # shuffle dataset first so that we can unbiases subsamples
  
    folds <- createFolds(allData[,ncol(allData)], k = 10, list = TRUE)
        
    # creating a list of length(gammas) x length(costs) x #folds for parallelization
    
    configurations <- list(gamma = numeric(0), cost = numeric(0), fold = integer(0))
    lindex <- 1
    
    for(gamma in gammas){
        for(cost in costs){
            for(i in 1:10){
                configurations[[lindex]] <- list(gamma = gamma, cost = cost, fold = i)
                lindex <- lindex + 1
            }
        }
    }
    
    results <- foreach(config=configurations, .combine = "rbind") %dopar%{
            
            gamma <- unlist(config)[1]
            cost <- unlist(config)[2]
            i <- unlist(config)[3]
            
            library(e1071)
            library(caret)
            
            preObj <- preProcess(allData[-folds[[i]], -ncol(allData)], 
                                 method = c("center", "scale"))
            
            trainData <- predict(preObj, allData[-folds[[i]], -ncol(allData)])
            validData <- predict(preObj, allData[folds[[i]], -ncol(allData)])
            
            trainData <- cbind(trainData, allData[-folds[[i]], ncol(allData)])
            validData <- cbind(validData, allData[folds[[i]], ncol(allData)])
            
            model <- svm(x = trainData[,-ncol(trainData)],
                         y = trainData[,ncol(trainData)],
                         scale = FALSE,
                         type = "C-classification", 
                         kernel = "radial", 
                         gamma = gamma, cost = cost)
            
            prediction <- predict(model, validData[,-ncol(trainData)])
            cfm <- table(prediction, validData[,ncol(trainData)])
            #print(cfm)
            error <- 1 - sum(diag(cfm))/sum(cfm)
            
            result <- data.frame(gamma = gamma, cost = cost, fold = i, error = error)
            
            result
            
    } # end foreach
    
    rownames(results) <- 1:nrow(results)
    results <- with(results, aggregate(results$error, 
                            by = list(gamma = gamma, cost = cost), 
                            FUN = "mean"))
    
    library(plyr)
    results <- arrange(results, gamma, cost)
    #print(results)
    
    if(kcl)
        stopCluster(cl)  
    
    minInd <- which.min(results$x)
    return(results[minInd,])
}

get_data <- function(tag) {
    
    require(caret)
    
    train <- read.csv("pml-training.csv", na.string = c("", "NA"))
    test <- read.csv("pml-testing.csv", na.string = c("", "NA"))
    missValuesFraction <- unname(apply(X = train, MARGIN = 2, FUN = function(x){1 - (table(is.na(x))[1]/sum(table(is.na(x))))[[1]]}))
    missIndex <- which(missValuesFraction > 0)
    train <- train[, -missIndex]
    test <- test[, -missIndex]
    train <- train[, 8:60]
    test <- test[, 8:60]
    preObj <- preProcess(train[, 1:52], method = c("center", "scale"))
    
    train[,1:52] <- predict(preObj, train[,1:52])
    
    test[,1:52] <- predict(preObj, test[,1:52])
    
    if(tag=="train")
        return(train)
    else
        return(test)
}

genError <- function(data, k = 5){
    
    library(caret)
    library(parallel)
    library(doParallel)
    library(e1071)
    
    numCores <- detectCores()
    cl <- makeCluster(numCores)  
    
    folds <- createFolds(y = data[,53], k = k, list = T)
    
    error <- 0
    
    for(i in 1:k){
        print(paste("Fold ",i))
        params <- tune_SVM(list(inputs = data[-folds[[i]], 1:52], 
                                         targets = data[-folds[[i]],53]),
                            gammas = c(0.25,0.5,0.75), costs = c(0.5, 1, 1.5),
                            cluster = cl, kcl = (i == k))
       
        g <- params[[1]]
        c <- params[[2]]
        
        preObj <- preProcess(data[-folds[[i]], 1:52], method = c("center", "scale"))
        
        trainSet <- cbind(predict(preObj, data[-folds[[i]], 1:52]), 
                          data[-folds[[i]],53])
        validSet <- cbind(predict(preObj, data[folds[[i]], 1:52]), 
                       data[folds[[i]],53])
        
        model <- svm(x = trainSet[,1:52], y = trainSet[,53], 
                     scale = F, type = "C-classification", 
                     kernel = "radial", gamma = g, cost = c)
        
        prediction <- predict(model, validSet[,1:52])
        
        cfm <- table(prediction, validSet[,53])
        
        error <- error + (1 - sum(diag(cfm))/sum(cfm))
        print(1 - sum(diag(cfm))/sum(cfm))
    }
    
    error <- error/k
    
    print(paste("Generalization error: ", error))
}