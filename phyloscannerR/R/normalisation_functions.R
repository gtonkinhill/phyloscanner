# This function returns a normalisation constant for a genome window bounded by start and end.

#' @keywords internal
#' @export lookup.normalisation.for.tree

lookup.normalisation.for.tree <- function(ptree, lookup.df, lookup.column = "NORM_CONST"){

  if(is.null(ptree$window.coords)){
    stop(paste0("Tree ", ptree$name, "has no window coordinates" ))
  }
  if(length(ptree$window.coords)!=2){
    stop(paste0("Tree ", ptree$name, "has malformed window coordinates" ))
  }
  return(.lookup.normalisation.for.coords(ptree$window.coords$start, ptree$window.coords$end, lookup.df, lookup.column))
}

#' @keywords internal
#' @export .lookup.normalisation.for.coords

.lookup.normalisation.for.coords <- function(start, end, lookup.df, lookup.column = "NORM_CONST"){
  if(!(lookup.column %in% colnames(lookup.df))){
    stop(paste0("No column called ",lookup.column," in lookup data frame."))
  }

  window.rows <- lookup.df %>% filter(POSITION<=end & POSITION>=start)
  
  if(nrow(window.rows)==0){
    stop("Window ",start,"-",end," overlaps no coordinates in lookup file. Consider excluding this tree from the analysis, or disabling patristic distance normalisation.")
  }
  
  return(mean(window.rows %>% pull(lookup.column))) 
}
