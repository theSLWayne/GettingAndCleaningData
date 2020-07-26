library(knitr)
library(markdown)

# Creating analysis report
knit("run_analysis.Rmd", output = 'run_analysis.md', encoding = 'UTF-8', quiet = T)
markdownToHTML('run_analysis.md', 'run_analysis.html')

# Writing data table with tidy data into a .txt file as requested
write.table(dTableTidy, 'TidyData.txt', quote = F, sep = "\t", row.names = F)

# Creating codebook
knit('codebook.Rmd', output = 'codebook.md', encoding = 'UTF-8', quiet = T)
markdownToHTML('codebook.md', 'codebook.html')