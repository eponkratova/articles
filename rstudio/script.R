df <- read.csv("C:/Users/Eka/Documents/rstudio/test_rstudio/rstudio/df.csv")
df_sbuset <- df[, c("Country.Code","X1967")]
hist(df_sbuset$X1967)
