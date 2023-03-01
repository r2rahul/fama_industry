# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
purrr::walk(
  list.files(here::here("R/"),
        pattern = "*.r",
        full.names = TRUE,
        recursive = TRUE,
        ignore.case = TRUE
             ),
    ~source(.x)
)

# Set target options:
tar_option_set(
  format = "qs" # efficient format
  # Set other options as needed.
)


# Defines the pipeline of tasks to execute
# Naming convention, SIC related targets are defined starting with sic_ and
# Fama related targets starts with Fama. Finally targets converting data to tabular
# format is converted to tidy_
list(
  # Fama Data url
  tar_url(
    name = fama_dataurl,
    command = fama_url
  ),
  # Download the data
  tar_target(
    name = fama_zipdata,
    command = fetch_fama(fama_dataurl, folder_loc)
  ),
  # Unzip the Fama data
  tar_target(name = fama_file,
             command = extract_zip(fama_zipdata, out_dir)),
  #Read Fama File
  tar_target(name = fama_data,
             command = read_fama(fama_file)),
  # Get osha sic table
  tar_file(name = sic_file,
           command = "data/oshasic/sic_manual.csv"),
  tar_target(name = sic_osha,
             read_csv(sic_file)
             ),
  # Fetch SIC from sec and wiki
  tar_target(name = sic_secwiki,
            fetch_secwiki_sic(sic_sec_url, sic_wiki_url)
  ),
  # Combine the three sources
  tar_target(name = sic_dict,
             combine_sic(sic_osha, sic_secwiki)
  ),
  # Convert to tabular format
  tar_target(name = tidy_fama,
             command = tidy_famaind(fama_data, sic_dict)
             ),
  # Create output file
  tar_target(name = tidy_out,
              command = write_fama_sic(tidy_fama, out_tidy)
  ),
  # Generate data report
  tar_render(name = tidy_report,
             path = rpt_path,
             params = list(df = tidy_fama)),
             knit_root_dir = getwd()
)
