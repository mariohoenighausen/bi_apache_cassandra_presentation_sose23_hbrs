from cassandra.cluster import Cluster
from cassandra.query import BatchStatement
import csv
import time 

cluster = Cluster(['127.0.0.1'])
session = cluster.connect('historical_sales_and_active_inventory');


start_time = time.time()

create_key_space_stmt = session.prepare("""CREATE KEYSPACE IF NOT EXISTS historical_sales_and_active_inventory WITH REPLICATION = 
{'class':'NetworkTopologyStrategy','replication_factor':1};
""")

session.set_keyspace('historical_sales_and_active_inventory')
create_table_stmt = session.prepare("""
CREATE TABLE IF NOT EXISTS sales_by_sold_count (
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
""")

session.execute(create_key_space_stmt)
session.execute(create_table_stmt)

insert_stmt = session.prepare("""INSERT INTO sales_by_sold_count 
(Order_Id,File_Type,SKU_number,SoldFlag,SoldCount,MarketingType,ReleaseNumber,
New_Release_Flag,StrengthFactor,PriceReg,ReleaseYear,ItemCount,LowUserPrice,LowNetPrice) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )""")
with open('./data/SalesKaggle3.csv',newline='') as csvfile:
    reader = csv.reader(csvfile)
    next(reader) # skips the header row
    line_count = sum(1 for row in reader)

    print(f"Lines in the CSV without header: {line_count}")

    batch_size = 100
    count = 0
    batch = BatchStatement()
    
    for row in reader:
        order_id = int(row[0])
        file_type = row[1]
        sku_number = int(row[2])
        sold_flag = row[3]
        sold_count = int(row[4]) if type(row[4]) is int else 0  
        marketing_type = row[5]
        release_number = int(row[6])
        new_release_flag = row[7]
        strength_factor = float(row[8])
        price_reg = float(row[9])
        release_year = int(row[10])
        item_count = int(row[11])
        low_user_price = float(row[12])
        low_net_price = float(row[13])

        batch.add(insert_stmt,[order_id,
                               file_type,
                               sku_number,
                               sold_flag,
                               sold_count,
                               marketing_type,
                               release_number,
                               new_release_flag,
                               strength_factor,
                               price_reg,
                               release_year,
                               item_count,
                               low_user_price,
                               low_net_price])
        
        count += 1
        if count == batch_size:
            session.execute(batch)
            batch.clear()
            count = 0

    if count > 0:
        session.execute(batch)

row = session.execute("SELECT COUNT(*) FROM sales_by_sold_count;")
for r in row:
    print(r)

session.shutdown()
cluster.shutdown()
end_time = time.time()

print(f"The insertion of {line_count} rows took : {end_time - start_time} seconds")
