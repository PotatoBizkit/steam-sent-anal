library(jsonlite)

game_list_url <- "https://api.steampowered.com/ISteamApps/GetAppList/v2/"

# Try fetching the data, handle errors
tryCatch({
  game_data <- fromJSON(game_list_url)
  game_df <- as.data.frame(game_data$applist$apps)
  print(head(game_df))
}, error = function(e) {
  cat("❌ Failed to fetch data. Check your internet or Steam API.\n")
})

# Remove unwanted entries
game_df <- subset(game_df, !grepl("(?i)demo|dlc|soundtrack|ost", name))

# Save cleaned version
write.csv(game_df, "steam_games_cleaned.csv", row.names = FALSE)

cat("✅ Filtered dataset saved! Total games:", nrow(game_df), "\n")
