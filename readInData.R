library(stringr)

# The following function reads files, and combines them into a data.frame:
get.data.frame <- function(file.names) {
  tmp <- as.data.frame(read.table(file.names[1]))
  if(length(file.names)>1) {
    for(file.name in file.names[2:length(file.names)])
    tmp <- cbind(tmp,as.data.frame(read.table(file.name)))  
  }
  tmp
}

# The following is the most important function, which reads in data from the appropriate data set:
read.in.data <- function(data.set="test") {
  
  path.to.dir <- sprintf("UCI HAR Dataset/%s",data.set)
  
  subjects <- get.data.frame(sprintf("%s/subject_%s.txt",path.to.dir,data.set))
  labels <- get.data.frame(sprintf("%s/y_%s.txt",path.to.dir,data.set))
  label.names <- as.vector(read.table("UCI HAR Dataset//activity_labels.txt")[,2])
  
  column.names <- c("subject","label")
  X <- get.data.frame(sprintf("%s/X_%s.txt",path.to.dir,data.set))
  
  feature.names <- read.table("UCI HAR Dataset/features.txt")[,2]
  which.interesting.bool <- grepl("-mean\\(",feature.names)+grepl("-std",feature.names)
  which.interesting <- which(as.logical(which.interesting.bool))
  
  tmp <- cbind(subjects,labels,X[,which.interesting])
  names(tmp) <- c("subject","label",as.vector(feature.names)[which.interesting])
  
  tmp$subject <- as.factor(tmp$subject)
  tmp$label <- as.factor(label.names[tmp$label])
  
  tmp
}


# I read in the data:
test.df <- read.in.data("test")
train.df <- read.in.data("train")
  
# I assert that there are different subjects in the test data set and the train data set:
#assert(length(intersect(levels(a$subject),levels(b$subject)))) 
  
total.df <- rbind(test.df,train.df)
non.tidy.names <- names(total.df)
tidy.names <- tolower(as.vector(sapply(non.tidy.names,function(x) str_replace_all(x,"[()-]","") )))
  

tidy.data.matrix <- matrix(nrow=length(levels(total.df$subject))*length(levels(total.df$label)),ncol=dim(total.df)[2])
row <- 1
for(sub in levels(total.df$subject)) {
  for(activity in levels(total.df$label)) {
    tidy.data.matrix[row,] <- c(sub,activity,as.vector(colMeans(total.df[total.df$subject==sub & total.df$label==activity,3:dim(total.df)[2]]))) 
    row <- row + 1
  } 
}

tidy.data.df <- as.data.frame(tidy.data.matrix)
names(tidy.data.df) <- tidy.names

write.table(tidy.data.df,"tidy.txt",row.names=F)
