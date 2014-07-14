##---------------------------------------------------------------------------------##
## plot3.R is a script that downloads recreates 3 of 4 varied plots from R.Peng's  ##
## ExData_plotting git repo. It uses a set of data from the UC Irvine Machine      ##
## Learning repository, specifically a dataset of individual household electric    ##
## power consumption over a 4 year time period. The script performs the following: ##
## 1. Downloads a dataset and unzips it                                            ##          
## 2. loads a data.table from the .txt file in the root dir                        ##
## 3. subsets that data file for the folowing date range: 2007-02-01 ~ 2007-02-02  ##                                                                                      
## 4. recreates one of four plots in the features folder of the ExData repo on the ##                                                                                      
##    screen graphic device                                                        ##                                                                                      
## 5. copies that screen output to a png file (of the same name as the script)     ##                                                                                      
##---------------------------------------------------------------------------------##

plot3 <- function(){
        
        Sys.setlocale("LC_TIME", "C") ## adjust for multiple timezones
        
        ##--------------1. CHECK FOR TXT FILE OR ZIP FILE ELSE DOWNLOAD AND UNZIP-----------------------##
        ## check for Dataset in root level folder
        ## if not found check for dataset zip
        ## and if zip not found then download the dataset from the internet, unzip and proceed
        ##https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
        
        if(file.exists("household_power_consumption.txt")){
                print("Dataset already downloaded and unzipped")
                print("Loading Data...")
        }else if(file.exists("exdata_data_household_power_consumption.zip")){
                print("Dataset downloaded. Now Unzipping...")
                unzip("./exdata_data_household_power_consumption.zip")
                print("Completed.")
                print("Loading Data...")
        }else if(!file.exists("exdata_data_household_power_consumption.zip")){
                print("Downloading and unzipping dataset...")
                download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "getdata_projectfiles_UCI HAR Dataset.zip")
                unzip("./exdata_data_household_power_consumption.zip")
                print("Completed.")
                print("Loading Data...")
        }
        
        ##--------------2. OPENING DATA.TABLES-----------------------##
        ## open 133 MB file named household_power_consumption.txt 
        ## it is a file with 2075259 obs and 9 variable names
        OriginalData <-read.table("./household_power_consumption.txt", header=TRUE, sep=";", na.strings="?", stringsAsFactors=FALSE)
        print("Data Loaded.")
        print("Pre-Processing Data...")
        
        ##------------------3. SUBSET DATA.TABLE-----------------##
        ## convert Date string in to Data class format using as.Date
        ## subset the OriginalDataset for only the specified date range: 2007-02-01 ~ 2007-02-02 
        OriginalData$Date<-as.Date(OriginalData$Date, "%d/%m/%Y")
        SubsetData <- OriginalData[which(OriginalData$Date == "2007-02-01" | OriginalData$Date == "2007-02-02"),]
        print("Data Processed.")
        print("Plotting Data...")
        
        ## --------------PRODUCE THE PLOT USING BASE-------------------##
        ## make a new col with the time and date combined and convert that to a POSIXlt object
        SubsetData$ConcatenateTimeDate <- paste(SubsetData$Date, SubsetData$Time) 
        SubsetData$ConcatenateTimeDate <- strptime(SubsetData$ConcatenateTimeDate, format="20%y-%m-%d %H:%M:%S")
        
        par(bg="transparent", mar=c(5,5,4,2)) ## set the background to transparent
        
        png(file = "plot3.png")
        plot(SubsetData$ConcatenateTimeDate,SubsetData$Sub_metering_1,ylab="Energy Sub metering",xlab="", type="l",
             cex.lab=0.8, cex.axis=0.8, cex.main=1, cex.sub=0.8, col="black") ## reduce magnification to reduce font size
        lines(SubsetData$ConcatenateTimeDate,SubsetData$Sub_metering_2, col="red")
        lines(SubsetData$ConcatenateTimeDate,SubsetData$Sub_metering_3, col="blue")
        legend("topright", legend=c("Sub_metering_1", "Sub_metering_1", "Sub_metering_1"), xjust=1, 
               cex=0.8, bg="transparent", lwd=1, lty=1, col=c("black", "red", "blue"))
        print("PNG created.")
        print("closing device...")
        dev.off() ## Don't forget to close the PNG device!
        print("Script Completed")
}
