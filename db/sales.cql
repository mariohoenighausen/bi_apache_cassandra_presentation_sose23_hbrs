-- Create a keyspace
CREATE KEYSPACE IF NOT EXISTS historical_sales_and_active_inventory WITH REPLICATION = 
{'class':'NetworkTopologyStrategy','replication_factor':'1'};

-- Set the keyspace to be used
USE historical_sales_and_active_inventory;

-- Create a table with Order_Id as partition key and SoldCount as cluster key
CREATE TABLE sales_by_sold_count (
    Order_Id INT,
    File_Type VARCHAR,
    SKU_number int,
    SoldFlag TEXT,
    SoldCount INT,
    MarketingType VARCHAR,
    ReleaseNumber INT,
    New_Release_Flag TEXT,
    StrengthFactor FLOAT,
    PriceReg FLOAT,
    ReleaseYear INT,
    ItemCount INT,
    LowUserPrice FLOAT,
    LowNetPrice FLOAT,
    PRIMARY KEY ((Order_Id),SoldCount)
   
) WITH CLUSTERING ORDER BY (SoldCount DESC);

-- temporarily insert a record if the record doesn't yet exist
INSERT INTO sales_by_sold_count(Order_Id,File_Type,SoldCount) VALUES(1000002,'Historical',10) IF NOT EXISTS USING TTL 10;
-- select from a table with condition
SELECT * FROM sales_by_sold_count WHERE Order_Id = 1000002;
-- temporarily update a record inside of a table 
UPDATE sales_by_sold_count USING TTL 10 SET ReleaseNumber = 100 WHERE order_id=1000002 AND soldcount = 10 IF EXISTS;
-- delete a record from a table
DELETE FROPM sales_by_sold_count WHERE order_id = 1000002 IF EXISTS; -- Nur für besseren Output