############################################################################
# Generate arrivals
############################################################################
setwd("~/Desktop/Ikea_Case")
#Sampling period:
Dates = seq(as.Date("2016/1/1"), as.Date("2016/6/1"), "days") #half a year

#10 minute window for arrivals: 10-18
Windows = seq(1,(10*60)/10)

#Customer arrivals:
Days = data.frame(Date=c(as.Date(Dates[1])),Interval=NA,Arrivals=NA,Checkouttimes=NA)
Days = Days[-1,]

#for each date, generate values:
for (i in 1:length(Dates)){
  
  #for every 10th minute in an 8-hour opening window:
  vals = data.frame(Interval=NA,Arrivals=NA,Checkouttimes=NA)
  vals = vals[-1,]
  
  for(j in 1:length(Windows)){
    #different distribution per day of week
    if(weekdays(as.Date(Dates[i])) == "Mandag" | 
       weekdays(as.Date(Dates[i])) == "Tirsdag" |
       weekdays(as.Date(Dates[i])) == "Onsdag" | 
       weekdays(as.Date(Dates[i])) == "Torsdag"){
        value = rpois(1,lambda = 12)
    }
    if(weekdays(as.Date(Dates[i])) == "Fredag"){
      value = rpois(1,lambda = 24)
    }    
    if(weekdays(as.Date(Dates[i])) == "Lørdag"){
      value = rpois(1,lambda = 32)
    }
    if(weekdays(as.Date(Dates[i])) == "Søndag"){
      value = rpois(1,lambda = 26)
    }
    
    #Generate a discrete stochastic component
    e = round(runif(1,min=0,max=5))
    
    #Add the stochastic component
    Arrivals = value + e
    
    #For every arrival, draw a gamma distributed number:
    if(value != 0){
      Checkouttimes = rgamma(Arrivals, shape=4, scale=1)  
      Arrivals = rep(Arrivals,length(Checkouttimes))
      Interval = rep(j,length(Checkouttimes))
    }
    
    Arrivals_Checkout = data.frame(Interval,Arrivals,Checkouttimes)
    vals <- rbind(vals,Arrivals_Checkout)
  }
  
  Date = rep(Dates[i],nrow(vals))
  
  Day_i = data.frame(Date,vals)
  Days <- rbind(Days,Day_i)
  
}

#Add weekday name;
Days$Weekday = weekdays(as.Date(Days$Date))
Days <- subset(Days, Weekday != "Søndag")

########################## INSPECTION ###########################

#Inspect the distribution of the arrivals
hist(Days$Arrivals)
summary(Days$Arrivals)

#Inspect the distribution of the checkout time
#hist(Days$Checkouttimes)
#summary(Days$Checkouttimes)

#Inspect averages by group:
#aggregate(Days[, "Checkouttimes"], list(Days$Weekday), mean)
aggregate(Days[, "Arrivals"], list(Days$Weekday), mean)

library(gplots)
#plotmeans(Checkouttimes ~ Weekday, data = Days, frame = FALSE)
plotmeans(Arrivals ~ Weekday, data = Days, frame = FALSE)

################################################################################
# Store the simulated data
################################################################################

write.table(Days,file="SimulatedData.csv",
            sep=",",dec = ".",row.names = FALSE)


