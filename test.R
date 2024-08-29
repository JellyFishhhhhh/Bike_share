# Load necessary libraries
library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

# Set the path to the directory containing the files
path <- "/Users/jellyfish/Documents/Untitled/My-repo/bike"

# List all files containing "tripdata" in their name
files <- list.files(path = path, pattern = "tripdata", full.names = TRUE)

# Read all files and combine them into one data frame
all_data <- lapply(files, read_csv) %>%
  bind_rows()

# Preview the combined data
head(all_data)

# Calculate the duration
all_data$duration <- all_data$ended_at - all_data$started_at

# Convert duration to different units (e.g., minutes)
all_data$duration <- as.numeric(all_data$duration, units = "mins")
all_data$duration <- round(all_data$duration, 1)

# Add new columns for month, year, and weekday
all_data$month <- format(all_data$started_at, "%m")
all_data$year <- format(all_data$started_at, "%Y")
all_data$weekday <- weekdays(all_data$started_at)

# Drop rows where duration is less than 1 mins
all_data <- all_data[all_data$duration >= 1, ]

# Create a bar plot showing the number of users by type
ggplot(all_data, aes(x = member_casual)) +
    geom_bar(fill = "lightblue", color = "black") +
    labs(title = "Number of Users by Type",
        x = "User Type",
        y = "Count") +
    theme_minimal()

# Summarize the data
member_rideable <- all_data %>%
    group_by(member_casual, rideable_type) %>%
    summarize(count = n(), .groups = 'drop')%>%
    group_by(member_casual)%>%
    mutate(percent = count/sum(count)*100) %>%
    ungroup

# Grouped Bar Plot
ggplot(member_rideable, aes(x = member_casual, y = count, fill = rideable_type)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Bike Usage by Customer Type and Bike Type",
        x = "Customer Type",
        y = "Usage Count",
        fill = "Bike Type") +
    theme_minimal() +
    scale_y_continuous(labels = scales::comma) + 
    scale_fill_brewer(palette = "Set2") +  # Change color palette 
    geom_text(
        aes(label = paste0(format(count, big.mark = ","), " (",round(percent, 1), "%)")), 
        size = 3, 
        hjust = 0.5, 
        vjust = 9,
        position = position_dodge(width = 1)
    )

# Determine Top 10 stations by ridership
top_stations <- all_data %>%
    filter(!is.na(start_station_name)) %>%
    group_by(start_station_name, member_casual) %>%
    summarise(number_rides = n(), .groups="drop_last") %>%
    group_by(start_station_name) %>%
    mutate(total_rides = sum(number_rides)) %>%
    slice_max(order_by = total_rides, n = 1) %>%
    ungroup() %>%
    arrange(desc(total_rides)) %>%
    mutate(percent = number_rides/total_rides*100) %>%
    top_n(10, total_rides)

# Plot Top 5 stations by ridership
ggplot(top_stations, aes(x = reorder(start_station_name, total_rides), y = number_rides, fill = member_casual)) +
    geom_bar(stat = "identity", width = 0.7) +
    geom_text(aes(label=paste0(round(percent), "%")),
            position = position_stack(vjust = 0.5)) + 
    coord_flip() +
    labs(title = "Top 5 stations by ridership",
        x = "Station",
        y = "Total Rides",
        fill = "Member Type") +
    theme_minimal() +
    scale_y_continuous(labels = scales::comma) + 
    scale_fill_brewer(palette = "Set2")

# Define the month names
month_names <- c("January", "February", "March", "April", "May", "June",
                  "July", "August", "September", "October", "November", "December")
# Convert numeric month to month names
all_data$month <- month_names[as.numeric(all_data$month)]

# Convert month to ordered factor
all_data$month <- ordered(all_data$month, levels = month_names)

# Summarize the monthly data
month_summary <- all_data %>% 
  group_by(month, member_casual) %>%
  summarise(count = n(), .groups = "drop")%>%
  arrange(month, member_casual)

# Plot monthly data
ggplot(month_summary, aes(x = month, y = count, fill = member_casual)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Monthly Usage by Customer Type",
        x = "Month",
        y = "Usage Count",
        fill = "Customer Type") +
    scale_x_discrete(labels = month_names) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_brewer(palette = "Set2") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom") +
    theme_minimal()

# Convert weekday to ordered factor
weekday_names <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
all_data$weekday <- ordered(all_data$weekday, levels = weekday_names)

# Summarize the weekly data
weekday_summary <- all_data %>% 
  group_by(weekday, member_casual) %>%
  summarise(count = n(), .groups = "drop")%>%
  arrange(weekday, member_casual)

# Plot weekly data
ggplot(weekday_summary, aes(x = weekday, y = count, fill = member_casual)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Weekly Usage by Customer Type",
        x = "Weekday",
        y = "Usage Count",
        fill = "Customer Type") +
    scale_x_discrete(labels = weekday_names) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_brewer(palette = "Set2") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom") +
    theme_minimal()

# Calculate mean duration by month and rider type
mean_duration_summary <- all_data %>%
  group_by(month, member_casual) %>%
  summarise(mean_duration = mean(duration), .groups = "drop")%>%
  ungroup

# Plot mean duration by month and rider type by line chart
ggplot(mean_duration_summary, aes(x = month, y = mean_duration, color = member_casual, group = member_casual)) +
  geom_line() +
  labs(title = "Mean Duration by Month and Customer Type",
       x = "Month",
       y = "Mean Duration (minutes)") +
  scale_x_discrete(labels = month_names) +
  geom_point() +
  scale_color_brewer(palette = "Set2") +
  theme_minimal()
