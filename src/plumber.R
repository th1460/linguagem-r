#* @apiTitle Prediction Survived in Titanic Disaster

#* @param sex Sex
#* @param pclass Class
#* @post /predict
function(sex, pclass) {
    
    board <- pins::board_s3(bucket = Sys.getenv("COS_BUCKET"),
                            region = Sys.getenv("COS_REGION"),
                            access_key = Sys.getenv("COS_ACCESS_KEY_ID"),
                            secret_access_key = Sys.getenv("COS_SECRET_ACCESS_KEY"),
                            endpoint = Sys.getenv("COS_ENDPOINT"))
    model <- board |> pins::pin_read("titanic-model")
    input <- list(Sex = sex, Pclass = pclass)
    pred <- tidypredict::tidypredict_to_column(as.data.frame(input), model)
    
    return(pred)
    
}