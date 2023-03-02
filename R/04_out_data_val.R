
#' Write Fama to CSV file
#'
#' @param tidy_fama The Fama Industry in tidy format
#' @param out_file The output file path
#'
#' @return output 
#' @export
#'
#' @examples
#' tar_load(tidy_fama)
#' out_file <- "data/famatidy/fama_sic.csv"
#' csv_out <- write_fama_sic(tidy_fama, out_file)
write_fama_sic <- function(tidy_fama, out_file) {
  write_csv(tidy_fama, out_file)
  #return output file so that target can track changes
  return(out_file)
}
