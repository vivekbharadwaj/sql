# sql
## Some interesting sql scripts and functions that I create or come across

File | Description
--- | ----
Clean_repeated_file_loads.sql | clean up a table with multiple redundant file loads using LEAD and partition (SQL Server 2008)
moving_average_calculations.sql | calculate moving average of clinic appointments (SQL Server 2008)
data_entry_restrictions.sql | restrict data entry server side by using specific input formats (SQL Server 2008)
relative_table_size_calculations.sql | relative table sizes in a database expressed as a percentage of total space (SQL Server 2008)
Teradata_analytics_LEAD_LAG.sql | how to do lead and lag calculations in Teradata (Teradata)
Teradata_analytics_qualify_RANK.sql | rank functionality - select top n (mostly top 1) from a dimension group (Teradata);
import_from_sqlite_cmdline.sql | create tables, table constraints and load data from CSV using the SQLITE command line. ensure sqlite is imported into your environment before starting it. Type sqlite3 to get into the environment. Execute from the project root directory by typing .open DATA\\dbname (for windows). Then execute the file by reading it - .read SCRIPTS\\script_filename.sql  .. Remember you can also do this from Python. Better because you have better control over the column datatype.