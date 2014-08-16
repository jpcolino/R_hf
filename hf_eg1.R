# Clean the R console and workspace
cat("\014") 
rm(list = ls()) 

# Loading library and data:
library("highfrequency");
data("sample_tdata");
data("sample_qdata");

# Time aggregation:
ts = sample_tdata$PRICE
plot(ts)
tsagg30sec = aggregatets(ts,on="seconds",k=30);
plot(tsagg30sec)
tsagg5min = aggregatets(ts,on="minutes",k=5);
plot(tsagg5min)

# Binding time series:
stock1 = sample_tdata$PRICE;
stock2 = sample_qdata$BID;
mPrice_1min = cbind(aggregatePrice(stock1),aggregatePrice(stock2));

# Refresh time aggregation:
mPrice_Refresh = refreshTime(list(stock1,stock2));

# Calculate a jump robust volatility measures
# based on synchronized data: 
rbpcov1 = rBPCov(mPrice_1min,makeReturns=TRUE);
print(rbpcov1)
rbpcov2 = rBPCov(mPrice_Refresh,makeReturns=TRUE);
print(rbpcov2)

# Calculate a jump and microstructure noise robust volatility measure
# based on nonsynchronous data:
rtscov = rTSCov(list(stock1,stock2));

#Get sample daily Realized Volatility data
data(realized_library); 
DJI_RV = realized_library$Dow.Jones.Industrials.Realized.Variance; #Select DJI
DJI_RV = DJI_RV[!is.na(DJI_RV)]; #Remove NA's
DJI_RV = DJI_RV['2008'];
plot(DJI_RV)
x = harModel(data=DJI_RV , periods = c(1,5,22), RVest = c("rCov"), type="HARRV",h=1,transform=NULL);
print(class(x));
print (x);



