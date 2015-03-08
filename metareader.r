readWriteNewMetadata <- function(metadata.file, metadata.auto) {
	
	metadata <- read.table(metadata.file, sep='\t', header=T,comment.char = "#")

	#Calcluate the number of slides that were used in this analysis
	sample.numbers <- unique(metadata$SampleNumber)

	# Sanity check the number of slides and the number of entries in the metadata
	if (!(2*length(sample.numbers)==dim(metadata)[1])) {	
  	stop(paste("The metadata file does not have matched dye flips: ",
            sprintf('%d unique slide numbers, %d slides', length(sample.numbers),
                    dim(metadata)[1])))
	}
	
	#Double check that slide names are unique
	if( !(length(unique(unlist(metadata$ArrayName)) == length(metadata$ArrayName)))) {
		stop("Each slide must have a unique name")
	}

	name.finder <- function(x) {
		return(metadata[metadata$SampleNumber==x & metadata$ExpInCy5==1,"ArrayName"])
	}

	flip.finder <- function(x) {
		return(metadata[metadata$SampleNumber==x & metadata$ExpInCy5==0,"ArrayName"])
	}
	
	find.Cy5 <- function(x) {
		return(metadata[metadata$SampleNumber==x & metadata$ExpInCy5==1,"DataFile"])
	}
	find.Cy3 <- function(x) {
		return(metadata[metadata$SampleNumber==x & metadata$ExpInCy5==0,"DataFile"])
	}
	find.exp_name <- function(x, df) {
		return(metadata[metadata$SampleNumber==x & metadata$ExpInCy5==df,"ExpRNA"])
	}
	find.control_name <- function(x,df) {
		return(metadata[metadata$SampleNumber==x & metadata$ExpInCy5==df,"RefRNA"])
	}

	slide.names <- factor(sapply(sample.numbers, name.finder))
	slide.flips <- factor(sapply(sample.numbers, flip.finder))
	slide.cy5 <- sapply(sample.numbers,find.Cy5)
	slide.cy3 <- sapply(sample.numbers,find.Cy3)
	slide.expname.cy5 <- sapply(sample.numbers, find.exp_name,1)
	slide.conname.cy5 <- sapply(sample.numbers, find.control_name,1)
	slide.expname.cy3 <- sapply(sample.numbers, find.exp_name,0)
	slide.conname.cy3 <- sapply(sample.numbers, find.control_name,0)
	
	slideList <-data.frame(name=slide.names,flip=slide.flips, 
												 cy5_slide=slide.cy5, cy3_slide=slide.cy3,
												 exp.name.cy5=slide.expname.cy5, control.name.cy5=slide.conname.cy5,
												 exp.name.cy3=slide.expname.cy3, control.name.cy3=slide.conname.cy3)


	f=file(metadata.auto, 'w')
	write("Name\tFileName\tCy5\tCy3",f)
	for(idx in 1:dim(slideList)[1]) {
		slide <- slideList[idx,]
		slide1 <- sprintf("%s\t%s\t%s\t%s", slide$name, slide$cy5_slide, slide$exp.name.cy5, slide$control.name.cy5)
		slide2 <- sprintf("%s\t%s\t%s\t%s", slide$flip, slide$cy3_slide, slide$control.name.cy3, slide$exp.name.cy3)
		write(slide1, f)
		write(slide2, f)
	}
	close(f)
	return(slideList)
}