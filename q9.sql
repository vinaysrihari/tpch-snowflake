/* TPC_H Q9: Product Type Profit Measure Query

Business Question: The Product Type Profit Measure Query finds, for each
nation and each year, the profit for all parts ordered in that year that
contain a specified substring in their names and that were filled by a
supplier in that nation. The profit is defined as the sum of
[(l_extendedprice*(1-l_discount)) - (ps_supplycost * l_quantity)] for all
lineitems describing parts in the specified line. The query lists the nations
in ascending alphabetical order and, for each nation, the year and profit in
descending order by year (most recent first). 
*/
alter session set query_tag = 'tpch_q9';
select  nation,
        o_year,
        round(sum(amount), 2) as sum_profit
from    (
select  n_name as nation,
        extract(year from o_orderdate) as o_year,
        l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount
from    part,
        supplier,
        lineitem,
        partsupp,
        orders,
        nation
where   s_suppkey = l_suppkey
        and ps_suppkey = l_suppkey
        and ps_partkey = l_partkey
        and p_partkey = l_partkey
        and o_orderkey = l_orderkey
        and s_nationkey = n_nationkey
        and p_name like '%green%') as profit
group by    nation,
            o_year
order by    nation,
            o_year desc;
