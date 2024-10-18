create database banking;
use banking;

create table region (
  region_id INTEGER,
  region_name VARCHAR(9) 
);

INSERT INTO region
  (region_id, region_name)
VALUES
  ('1', 'Dhaka'),
  ('2', 'Khulna'),
  ('3', 'Rajshahi'),
  ('4', 'Sylhet'),
  ('5', 'Barishal');
 
 create table area
(
    area_id int,
    name varchar(20)
   
);

insert into area values (1,'Union'),
(2,'Upazila'),
(3,'Pouroshova'),
(4,'Ward'),
(5,'Village');

-- (................ETL.......................)
-- Now using python script I load Data for 
-- table 'customer_joining_info' and 'customer_transactions'

/* =>>>>>>>>>>>PYTHON SCRIPT<<<<<<<<<<<=
 * import pandas as pd
from sqlalchemy import create_engine

# Database connection details
mysql_engine = create_engine('mysql+pymysql://root:4march2023@localhost/banking')  

# List of tables and their corresponding CSV file paths
tables = {

    'customer_joining_info': 'customer_joining_info.csv',
    'customer_transactions': 'customer_transactions.csv',
    
}

for table, csv_file in tables.items():
    # Extract data from the CSV file
    df = pd.read_csv(csv_file)
    
    # Load data into the MySQL database
    df.to_sql(
        name=table,  
        con=mysql_engine,
        if_exists='replace',  
        index=False,
        method='multi',
        chunksize=1000
    )

print("Data loading completed successfully.")

 * */
-- ------------------------------------------------------------
use banking;

/* select * from customer_joining_info c
join region r on c.region_id=r.region_id ;*/

-- (................ETL.......................)
-- Now using python script I load Data for 
-- table 'customer_joining_info' and 'customer_transactions'


create database banking_backup;

/** =>>>>>>>>>>>PYTHON SCRIPT<<<<<<<<<<<=
 import pandas as pd
from sqlalchemy import create_engine
mysql_engine=create_engine('mysql+pymysql://root:4march2023@localhost/banking')
backup_mysql_engine=create_engine('mysql+pymysql://root:4march2023@localhost/banking_backup')
tables=['customer_transactions','customer_joining_info','area','region']
for table in tables:
    df=pd.read_sql_table(table,mysql_engine) # table for banking database
    df.to_sql(
        name=table,
        con=backup_mysql_engine, # connect database banking to banking_backup
        if_exists='replace',
        index=False,
        chunksize=1000
    )

print("Data loading completed successfully") 
 * */
-- day1 done...
-- -----------------------------------------------------------









