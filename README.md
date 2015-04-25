## Getting And Cleaning Data - My Project

I'll make it short.

I have two functions: "get.data.frame" and "read.in.data".
The first one reads a set of files and combines them into a data.frame.
The second reads the relevant data for a given data set ("train" or "test"), and merges them into a data.frame.

I upload the data into two variables: "test.df" and "train.df" (using "read.in.data").
Then, I combine them into "total.df".
Next, I tidy up the column names, and arrive at a variable "tidy.names".
And that's the data structure required in point 4 (of this assignment).

Once I've got the "total.df" data.frame, I calculate the means of each varible, and create a matrix, which I call "tidy.data.matrix".
From this matrix I create a data.frame ("tidy.data.df"), which I then output to a file "tidy.txt" (the one I uploaded at the coursera project page).

Thanks for reading,
MD
