write_fama_sic <- function(tidy_fama, out_file) {
  write_csv(tidy_fama, out_file)
  #return output file so that target can track changes
  return(out_file)
}
