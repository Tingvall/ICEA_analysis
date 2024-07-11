TG_theme <- function(base_size = 12,
                     base_family = "",
                     base_line_size = base_size / 50,
                     base_rect_size = base_size / 100,
                     aspect.ratio=1)
{
  theme_classic(base_size = base_size,
                base_family = base_family,
                base_line_size = base_line_size) %+replace%
    theme(
      #aspect.ratio = aspect.ratio,
      plot.title = element_text(
        color =  "black",
        #face = "bold",
        hjust = 0.5,
        size=rel(2),
        margin=margin(0,0,20,0)),
      axis.title = element_text(
        color =  "black",
        size = rel(1.75)),
      #axis.title.x = element_blank(),
      axis.text.y = element_text(
        color =  "black",
        size = rel(1.5),
        hjust=1),
      axis.text.x = element_text(
        color =  "black",
        size = rel(1.5),
        angle = 45,
        hjust=1,
        vjust=0.85),
      strip.text = element_text(
        color =  "black",
        size = rel(1.75),
        margin=margin(0,0,10,10)),
      strip.background = element_rect(
        fill=NA, color=NA),
      #axis.ticks.x=element_blank(),
      #axis.text.x = element_blank(),
      plot.margin = margin(0.2, 0.2, 1, 0.2, "cm"),
      legend.title = element_blank(),
      legend.text = element_text(
        color =  "black",
        size = rel(1.5)),
      complete = TRUE
    )
}
