main <- function() {

  args <- commandArgs(trailingOnly = TRUE)

  sno_file <- args[1]
  other_file <- args[2]
  out_file <- args[3]

  source("scripts/VCNet_sno_modif.R")
  PerformVCNet(sno_file, other_file, out_file)

}

main()
