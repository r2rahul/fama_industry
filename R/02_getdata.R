#' Title
#'
#' @param fama_url 
#' @param folder_loc 
#'
#' @return
#' @export
#'
#' @examples
fetch_fama <- function(fama_url, folder_loc) {
  if(!dir.exists(folder_loc)) {
    dir.create(folder_loc, recursive = TRUE)
  }
  out_file <- glue("{folder_loc}/Siccodes49.zip") %>%
    here::here()
  download.file(fama_url, out_file)
  return(out_file)
}

#' Title
#'
#' @param fama_zipfile 
#' @param out_filedir 
#'
#' @return
#' @export
#'
#' @examples
extract_zip <- function(fama_zipfile, out_filedir) {
  unzip(fama_zipfile, exdir = out_filedir)
  out_filepath <- glue("{out_filedir}/Siccodes49.txt")
  return(out_filepath)
}

#' Title
#'
#' @param out_fpath 
#'
#' @return
#' @export
#'
#' @examples
read_fama <- function(out_fpath) {
  readLines(out_fpath)
}

#' Title
#'
#' @param sic_sec_url 
#' @param sic_wiki_url 
#'
#' @return
#' @export
#'
#' @examples
fetch_secwiki_sic <- function(sic_sec_url, sic_wiki_url) {
  # Get the SEC SIC Names
  sic_sec <- read_html(sic_sec_url)
  sic_sec_tbl <- sic_sec %>%
    html_table()
  sic_sec_tbl <- sic_sec_tbl[[1]] %>%
    rename(
      sic_code = `SIC Code`,
      sic_group_name = Office
    ) %>%
    select(sic_code, sic_group_name)
  
  # Get Wiki SIC tbls
  sic_wiki <- read_html(sic_wiki_url)
  sic_wiki_tbl <- sic_wiki %>%
    html_table()
  sic_wiki_tbl <- sic_wiki_tbl[[2]] %>%
    rename(
      sic_code = `SIC Code`,
      sic_group_name = Industry
    ) %>%
    mutate(
      sic_code = str_replace_all(sic_code,
        "\\s+\\(\\d+\\.+\\)", "") %>%
        str_trim() %>%
        as.integer()
    )
  
  # Now check if wiki has new codes
  wiki_new <- anti_join(
    sic_wiki_tbl, sic_sec_tbl, 
    by = "sic_code"
  )
  # Now combine sic_sec_tbl and wiki_new
  sic_ref <- wiki_new %>%
      union(sic_sec_tbl) %>%
      arrange(sic_code)
  return(sic_ref)
}

fetch_old_sic <- function(sic_old_path) {
  read_csv(sic_old_path) %>%
    mutate(sic_code = as.integer(sic_code)) %>%
    select(sic_code, sic_group_name)
}

#' Title
#'
#' @param sic_osha 
#' @param sic_secwiki 
#' @param sic_old 
#'
#' @return
#' @export
#'
#' @examples
combine_sic <- function(sic_osha, sic_secwiki) {
  # Prepare sic_osha
  sic_osha <- sic_osha %>%
    mutate(
      sic_code = str_trim(sic_code) %>%
          as.integer(),
      sic_group_name = str_trim(sic_name)
      
    ) %>%
    select(sic_code, sic_group_name) %>%
    arrange(sic_code)
  # Take union of two
  sic_dict <- union(sic_osha, sic_secwiki) %>%
    arrange(sic_code)  
  return(sic_dict)
}
