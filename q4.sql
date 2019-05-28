/* TPC_H Q4: Order Priority Checking Query

The Order Priority Checking Query counts the number of orders ordered in a
given quarter of a given year in which at least one lineitem was received by
the customer later than its committed date. The query lists the count of such
orders for each order priority sorted in ascending priority order. 
*/ 
alter session set query_tag='tpch_q4';
select
        o_orderpriority,
        count(*) as order_count
from
        orders
where
        o_orderdate >= '1993-07-01'
        and o_orderdate < dateadd(month, 3, '1993-07-01')
        and exists (
                select
                        *
                from
                        lineitem
                where
                        l_orderkey = o_orderkey
                        and l_commitdate < l_receiptdate
        )
group by
        o_orderpriority
order by
        o_orderpriority;
