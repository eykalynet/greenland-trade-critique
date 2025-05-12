# Load required libraries
library(tidyverse)
library(showtext)
library(stringr)

# Add Google Font
font_add_google("Source Serif Pro", "ssp")
showtext_auto()

# Define seafood commodities
seafood_commodities <- c(
  "Total fish and shellfish",
  "Whole fish--fresh, chilled, or frozen",
  "Fish fillets and mince",
  "Shellfish, fresh or frozen",
  "Prepared fish and shellfish",
  "Fish and shellfish"
)

# Read and clean data
food <- read_csv("FoodImports.csv")

# Summarize import values by year and country
us_total_by_country <- food |>
  filter(Commodity %in% seafood_commodities) |>
  filter(!str_detect(Country, "WORLD")) |>
  group_by(YearNum, Country) |>
  summarise(Total_Import = sum(FoodValue, na.rm = TRUE), .groups = "drop")

# Title case country names
us_total_by_country <- us_total_by_country |>
  mutate(Country = str_to_title(Country))

# Always include Greenland, even if small
top_countries <- us_total_by_country |>
  group_by(Country) |>
  summarise(AllTimeTotal = sum(Total_Import)) |>
  arrange(desc(AllTimeTotal)) |>
  pull(Country)

# If Greenland not in top 10, add it
if (!"Greenland" %in% top_countries) {
  top_countries <- c(top_countries[1:9], "Greenland")
} else {
  top_countries <- top_countries[1:10]
}

# Filter and reorder Country factor by total import (descending)
filtered_data <- us_total_by_country |>
  filter(Country %in% top_countries)

country_order <- filtered_data |>
  group_by(Country) |>
  summarise(Total = sum(Total_Import)) |>
  arrange(desc(Total)) |>
  pull(Country)

filtered_data <- filtered_data |>
  mutate(Country = factor(Country, levels = country_order))

# Define Greenland-inspired palette (dark to light + red for Greenland)
greenland_soft_palette_desc <- c(
  "#2b5868", "#3a6b7f", "#4b7e95", "#5d91ab", "#6ea1bd",
  "#7aadc9", "#8fb9d2", "#a6c9dc", "#c1dce9", "#dceef5"
)

# Insert Greenland as red if present
if ("Greenland" %in% country_order) {
  country_order_no_greenland <- setdiff(country_order, "Greenland")
  final_palette <- setNames(
    c(greenland_soft_palette_desc[1:length(country_order_no_greenland)], "#bd0a1b"),
    c(country_order_no_greenland, "Greenland")
  )
} else {
  final_palette <- setNames(greenland_soft_palette_desc, country_order)
}

# Plot
p <- ggplot(filtered_data, aes(x = as.factor(YearNum), y = Total_Import, fill = Country)) +
  geom_col() +
  scale_fill_manual(values = final_palette) +
  labs(
    x = "Year",
    y = "Total Import Value (Million USD)",
    fill = "Country"
  ) +
  theme_minimal(base_family = "ssp") +
  theme(
    
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  )

# Save the plot
ggsave("images/seafood-imports-by-country.png", plot = p, width = 14, height = 8, dpi = 300)
