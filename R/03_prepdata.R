#' Title
#'
#' @param fama_data 
#' @param sic_dict 
#'
#' @return
#' @export
#'
#' @examples
tidy_famaind <- function(fama_data, sic_dict) {
  # Step 1
  # Split the file on emtpy lines i.e. "" char
  # The way to do it is by cumsum(fama_data == "")
  fama_list <- split(fama_data, cumsum(fama_data == ""))
  # Step 2 Iterate over each industry group
  # Define function fama_grp_extract
  # Return as tibble
  fama_tidy <- map_dfr(fama_list, fama_grp_extarct)
  # Step 3
  # Merge with SIC 4 digit industry classification
  # Convert sic code to integers
  sic_dict <- sic_dict %>%
    mutate(sic_code = as.integer(sic_code))
  fama_sic <- left_join(sic_dict, fama_tidy, 
                    by = c("sic_code" = "sic_code"))
  # Step 4
  # Clean the data
  fama_sic <- fama_sic %>%
    group_by(sic_code) %>%
    tidyr::fill(fama_ind49, .direction = "down") %>%
    filter(!is.na(fama_ind49)) %>%
    ungroup() %>%
    arrange(fama_ind49)
  return(fama_sic)
}


#' Title
#'
#' @param ind_grp 
#'
#' @return
#' @export
#'
#' @examples
fama_grp_extarct <- function(ind_grp) {
  #Step 2A Extract Fama group
  # Use regexp ^[0-9]{1,2}\s(.*)
  # get first vector, trim white spaces
  ind_grp <- ind_grp[ind_grp != ""]
  fama_grp <- ind_grp[1] %>%
    str_trim() %>%
    str_match_all("(^[0-9]{1,2})\\s(.*)")
  # Now get individual components
  fama_ind49 <- as.integer(fama_grp[[1]][2])
  # Remove extra white spaces
  fama_grpdesc <- str_squish(fama_grp[[1]][3])
  
  # Step 2B Get SIC grps in fama industry
  # Define a function fama_sic_extract
  sic_grp <- ind_grp[2:length(ind_grp)]
  sic_df <- map_dfr(sic_grp,
              fama_sic_extract)
  
  # Step 2C
  # Add fama industry
  sic_df <- sic_df %>%
    mutate(
      fama_ind49 = fama_ind49,
      fama_grpdesc = fama_grpdesc
    )
  return(sic_df)
}


#' Title
#'
#' @param sic_vec 
#'
#' @return
#' @export
#'
#' @examples
fama_sic_extract <- function(sic_vec) {
  # Step 2B.C
  # Get the sic groups
  # Use regexp (\d{4})-(\d{4})\s(.*)
  sic_ext <- sic_vec %>%
    str_trim() %>%
    str_match_all("(\\d{4})-(\\d{4})\\s(.*)")
  # Now get individual components
  sic_start <- as.integer(sic_ext[[1]][2])
  sic_end <- as.integer(sic_ext[[1]][3])
  sic_fama_desc <- str_squish(sic_ext[[1]][4])
  # Now create data frame from sic_start to sic_end
  sic <- tibble(
    sic_code = sic_start:sic_end,
    fama_sic_start = sic_start,
    fama_sic_end = sic_end,
    sic_fama_desc = sic_fama_desc
  )
  return(sic)
}
