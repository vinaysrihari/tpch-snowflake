/* TPC_H Q5: Local Supplier Volume Query

The Local Supplier Volume Query lists for each nation in a region the revenue
volume that resulted from lineitem transactions in which the customer ordering
parts and the supplier filling them were both within that nation. The query is
run in order to determine whether to institute local distribution centers in a
given region. The query considers only parts ordered in a given year. The
query displays the nations and revenue volume in descending order by revenue.
Revenue volume for all qualifying lineitems in a particular nation is defined
as sum(l_extendedprice * (1 - l_discount)).
*/
alter session set query_tag='tpch_q5';
select
        n_name,
        round(sum(l_extendedprice * (1 - l_discount)),2) as revenue
from
        customer,
        orders,
        lineitem,
        supplier,
        nation,
        region
where
        c_custkey = o_custkey
        and l_orderkey = o_orderkey
        and l_suppkey = s_suppkey
        and c_nationkey = s_nationkey
        and s_nationkey = n_nationkey
        and n_regionkey = r_regionkey
        and r_name = 'ASIA'
        and o_orderdate >= '1994-01-01'
        and o_orderdate < dateadd(year, 1, '1994-01-01')
group by
        n_name
order by
        revenue desc;
