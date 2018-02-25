lineNotify
==========

`lineNotify` - a package to send message to LINE using [LINE Notify](https://notify-bot.line.me)

### Overview

- `notify_msg` : send a message to LINE
- `notify_plot` : send a plot to LINE
- `notify_ggplot` : send a ggplot object to LINE

### Installation

``` r
devtools::install_github("fisproject/lineNotify")
```

### Usage

- Issue a personal access token from My Page of [LINE Notify](https://notify-bot.line.me)

``` r
library(lineNotify)

Sys.setenv(LINE_API_TOKEN="Your-Personal-Access-Token")

# send a message
notify_msg("hello world")

# send a image
plot(iris)
notify_plot("Plotting the Iris")

# send a ggplot object
library(ggplot2)
data(iris)
p <- ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length)) +
 geom_point()
notify_ggplot("Plotting the Iris", plot = p)
```
