#!/usr/bin/env Rscript

readRenviron(".Renviron")

# load model
board <- pins::board_s3(bucket = Sys.getenv("COS_BUCKET"), 
                        region = Sys.getenv("COS_REGION"), 
                        access_key = Sys.getenv("COS_ACCESS_KEY_ID"),
                        secret_access_key = Sys.getenv("COS_SECRET_ACCESS_KEY"),
                        endpoint = Sys.getenv("COS_ENDPOINT"))

model <- pins::pin_read(board, "titanic-model")

# input
input <- jsonlite::fromJSON("input.json", flatten = FALSE)

# predict
pred <- tidypredict::tidypredict_to_column(as.data.frame(input), model)

# output
jsonlite::stream_out(pred, verbose = FALSE)