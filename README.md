#	Brief from the client
This case is adapted from a tender made by a large furniture company. In the tender, the company wants to optimize its waiting time in key areas of the store, which will eventually increase sales per working hour (an internal KPI). The main goal is to utilize predictive analytics in order to optimize the staff-planning.

This example will focus on the cash area, where different service stations can be opened or closed, based on the demand.

The effectiveness of the effort will be measured by two KPI’s: 
- Reduction in waiting time
- Increase in sales per worked hour

# Solution
The suggested solution is a framework consisting of a LSTM neural network for predicting the sequence of customers over the next hour, based on the last 6 hours. Every prediction is a sequence of predicted total customers in 10-minute intervals. The next component is a Linear programmnig model that solves for the optimal amount of service desks, with respect to the staff costs and demand at time t. 
