INTRODUCTION
Adine Noodles is a fast-growing FMCG company in the instant noodles company with over two years experience in Noodle supply spread over various states in Africa is seeking to understand their data better due to rising competitions in the market, lapses in revenue and profit, location sale issues. They hired The A Company to perform an analysis on their data to dive into the data and bring out useful information and recommendation to help them stay in the market and grow in the industry.

EXECUTIVE SUMMARY
Adine Noodles commissioned this analysis to address increasing competition, revenue and profit pressures, and a clear mismatch between product demand and supply across its warehouse network. The primary objective was to develop a data-driven model capable of optimizing the weight of products shipped to each warehouse in order to reduce inventory losses and improve operational efficiency.
The analysis, conducted on 25,000 warehouse records using cleaned and structured historical data, reveals that Adine Noodles operates a predominantly rural distribution network (over 91%), with the highest warehouse concentration in the Northern region. Despite significant variation in the number and size of warehouses across zones, the average product ton delivered remains largely consistent (22,000 tons) across warehouse sizes and regions.
Importantly, findings show that warehouse quantity does not determine delivery volume; instead, capacity size and operational conditions have greater influence. Additionally, refill requests (demand proxy) show almost no statistical relationship with product weight delivered, confirming management’s concern that supply decisions are not currently aligned with demand patterns.

Critical Drivers of Product Delivery
From correlation and regression analysis (R² = 0.97), four operational variables significantly influence product weight delivered:
1.	Transport Issues (Negative Impact)
2.	Storage Issues (Strong Positive Impact)
3.	Temperature-Regulated Machinery (Positive Impact)
4.	Warehouse Breakdowns (Negative Impact)

Other factors—including demand (refill requests), competition levels, retail shop count, number of distributors, government checks, and warehouse distance from hubs—were found to have negligible impact on delivery weight.
Predictive Optimization Model

The following regression model was developed to forecast optimal product shipment weight:
y = (-300.25X₁) + (1257.32X₂) + (943.82X₃) - (228.04X₄) + 1304.36
Where:
•	X₁ = Transport Issues
•	X₂ = Storage Issues
•	X₃ = Temperature-Regulated Machines
•	X₄ = Warehouse Breakdowns

With an R² of 0.97, the model explains 97% of the variability in delivery weight and is suitable for operational forecasting and decision-making.
The findings indicate that Adine Noodles’ supply decisions are currently driven more by operational disruptions and infrastructure conditions than by actual demand signals. This misalignment is likely contributing to excess inventory in low-demand areas and shortages in high-demand areas.

To optimize performance and profitability, management should prioritize:
•	Reducing transport disruptions through preventive fleet maintenance and route optimization.
•	Investigating and correcting root causes of storage issues, especially overstocking and inventory mismanagement.
•	Strategically expanding temperature-regulated infrastructure in high-demand or high-capacity zones.
•	Improving warehouse reliability through preventive maintenance and backup systems.
•	Integrating the predictive model into planning dashboards for scenario simulation, weekly forecasting, and operational target setting.
