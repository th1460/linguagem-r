dataStocks <- function(code, from, to) {
    
    stock <- 
        quantmod::getSymbols(code, 
                             src = "yahoo", 
                             from = from, 
                             to = to, 
                             auto.assign = FALSE)
    
    stock <-
        stock |>
        as.data.frame() |> 
        tibble::rownames_to_column(var = "Date") |> 
        dplyr::as_tibble() |> 
        dplyr::select(dplyr::matches("Date|Adjusted")) |> 
        dplyr::mutate(Date = Date |> lubridate::as_date()) |> 
        dplyr::rename(Adjusted = 2)
    
    return(stock)
    
}