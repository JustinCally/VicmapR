as.vicmap_promise <- function(res) {
  structure(res,
            class = c("vicmap_promise", setdiff(class(res), "vicmap_promise"))
  )
}
