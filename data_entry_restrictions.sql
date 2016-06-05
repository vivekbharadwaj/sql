--SQL Server 2008

--If you want to restrict data entry in sql by using specific input formats, then you can do that by putting a constraint into the column
--example, if you want to restrict a column to a 5 letter alphanumeric such that first three are alphabets and last 2 are digits, then
ALTER TABLE tableName
  ADD CONSTRAINT ck_data_checker CHECK ([columnName] LIKE ('[A-Z][A-Z][A-Z][0-9][0-9]'))