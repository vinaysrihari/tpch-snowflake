/* TPC_H Q3: Shipping Priority Query

The Shipping Priority Query retrieves the shipping priority and potential
revenue, defined as the sum of l_extendedprice * (1-l_discount), of the orders
having the largest revenue among those that had not been shipped as of a given
date. Orders are listed in decreasing order of revenue. If more than 10
unshipped orders exist, only the 10 orders with the largest revenue are
listed. 
*/
alter session set query_tag='tpch_q3';
select
        l_orderkey,
        sum(l_extendedprice * (1 - l_discount)) as revenue,
        o_orderdate,
        o_shippriority
from
        customer,
        orders,
        lineitem
where
        c_mktsegment = 'BUILDING'
        and c_custkey = o_custkey
        and l_orderkey = o_orderkey
        and o_orderdate < '1995-03-15'
        and l_shipdate > '1995-03-15'
group by
        l_orderkey,
        o_orderdate,
        o_shippriority
order by
        revenue desc,
        o_orderdate
limit 10;
