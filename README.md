QUERY PLAN EXPLAINED:

Please refer to "ANALYZE_PRE" for the explain plan result after inserting 1M records randomly w/out any index created.
Prior to index creation the costs for the 3 queries are all high and all are performing full table scan for all the queries with relatively high cost. 
The biggest performance impact is on the 3rd query which used grouping method. This query both uses sorting (sorted by gender, round(salary,3)) and full table scan which is very slow and costly.
After indexes have been created (refer to ANALYZE_POST explain plan execution result), the explain plan shows significant performance improvement in the query plan. Cost and execution time have been been reduced.
From doing a full table scan for query A and B, it now uses the indexes created for filter columns. 
There was also query performance improvement the original query C, which uses the grouping.
On the ANALYZE_POST-C.1 result, you will see that just changing the group by column order to use the column which has the higher unique values, the execution time has been reduced to half even if it didn't use the index.
However after removing the round function from salary in the group by part of the query in ANALYZE_POST-C.2, you will see that performance has further improved.
The sorting method and full table scan has been replaced by the use of index person_gender_sal_idx which has reduced the query plan cost and execution time.
