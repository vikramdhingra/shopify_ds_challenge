# Author: Vikram Dhingra
# Date: 1 September 2020
# Shopify Data Science Challenge

# Loading Packages and setting up directory
x <- c("dplyr","gsheet","plotly","lubridate")
lapply(x,require,character.only=T)

# Reading Data directly from the Shopify googlesheet to the table
df <- gsheet2tbl('https://docs.google.com/spreadsheets/d/16i38oonuX1y1g7C_UAmiK9GkY7cS-64DfiDMNiR41LM/edit#gid=0')

# Checking the filestructure and few sanity checks before proceeding
str(df)
n_distinct(df$shop_id) #100 as mentioned in the question
mean(df$order_amount) # 3145.128

# As it is mentioned that it could be wrong
# Our first check is to check std dev of Order Amount
sd(df$order_amount) # 41282.54

#It is too high, lets plot the data
hist(log(df$order_amount))
plot_ly(x = ~df$order_amount, type = "histogram")%>% layout(title="Histogram of Order Amount")
plot_ly(x = ~log(df$order_amount), type = "histogram")%>% layout(title="Histogram of LOG Order Amount")

# Certainly there are outliers in the data. Let us investigate this
pairs(df[,-c(6,7)], pch = 19,  cex = 0.5,
      col = df$shop_id,
      lower.panel=NULL)

# Shop Id and Order Amount is of Interest from the Pair Plot
plot_ly(data = df, x = ~order_amount, y = ~shop_id,
               marker = list(size = 10,
                             color = 'rgba(222, 235, 52, .9)',
                             line = list(color = 'rgba(235, 52, 52, .8)',
                                         width = 2))) %>% layout(title = 'Scatter Plot Shop ID and Order Amount',
                      yaxis = list(zeroline = FALSE),
                      xaxis = list(zeroline = FALSE))

# It is clear that Shop ID 78 and 42 are prime suspect for
# reporting the correct numbers or are involved in some fraud.

# Lets Create 3 Dataframe 
# 1. 98 Shops ID excluding 78 and 42
# 2. 78 Shop ID
# 3. 42 Shop ID

df_98 <- df %>% dplyr::filter(!shop_id %in% c(78,42))
n_distinct(df_98$shop_id) #98
mean(df_98$order_amount) # 300.1558
sd(df_98$order_amount) # 155.9411

# This seems more reasonable in business context

# Now's lets study the outliers
# 78

df_78 <- df %>% dplyr::filter(shop_id == 78)
n_distinct(df_78$shop_id) #1
mean(df_78$order_amount) # 49213.04
sd(df_78$order_amount) # 26472.23
# After analyzing, it seems like 78 shop is selling sneakers at much higher price
# This is not specific to a user like in case of shop ID 42

# Now's lets study the outliers
# 42

df_42 <- df %>% dplyr::filter(shop_id == 42)
n_distinct(df_42$shop_id) #1
mean(df_42$order_amount) # 235101.5
sd(df_42$order_amount) # 334860.6

# After analyzing the result, it seems USER ID 607 is fraud or some bug or TEST user
# Transaction always occur at 4 AM
# Payment mode is always Credit Card
# If we exclude 607, then the new mean is 652.2353 and std dev is 358.6817 which is reasonable

#######################################################################################
#######   Lets calculate more metrics on this data
#######################################################################################

df$datetime <- lubridate::ymd_hms(df$created_at)

# Metric 1 : Weekly average Sales






