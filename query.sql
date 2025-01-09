WITH RegionalOrderStats AS (
    SELECT 
        c.Region,
        c.CustomerID,
        c.CustomerName,
        AVG(s.OrderAmount) AS AvgOrderValue
    FROM 
        Sales s
    JOIN 
        Customers c ON s.CustomerID = c.CustomerID
    GROUP BY 
        c.Region, c.CustomerID, c.CustomerName
),
RankedCustomers AS (
    SELECT 
        Region,
        CustomerID,
        CustomerName,
        AvgOrderValue,
        RANK() OVER (PARTITION BY Region ORDER BY AvgOrderValue DESC) AS RegionalRank
    FROM 
        RegionalOrderStats
)
SELECT 
    Region,
    CustomerID,
    CustomerName,
    AvgOrderValue,
    RegionalRank
FROM 
    RankedCustomers
WHERE 
    RegionalRank <= 2
ORDER BY 
    Region, RegionalRank;
