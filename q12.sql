/* TPC_H Q12: Shipping Modes and Order Priority Query

The Shipping Modes and Order Priority Query counts, by ship mode, for
lineitems actually received by customers in a given year, the number of
lineitems belonging to orders for which the l_receiptdate exceeds the
l_commitdate for two different specified ship modes. Only lineitems that
were actually shipped before the l_commitdate are considered. The late
lineitems are partitioned into two groups, those with priority URGENT or
HIGH, and those with a priority other than URGENT or HIGH. 
*/
alter session set query_tag='tpch_q12';
select
        l_shipmode,
        sum(case
                when o_orderpriority = '1-URGENT'
                        or o_orderpriority = '2-HIGH'
                        then 1
                else 0
        end) as high_line_count,
        sum(case
                when o_orderpriority <> '1-URGENT'
                        and o_orderpriority <> '2-HIGH'
                        then 1
                else 0
        end) as low_line_count
from
        orders,
        lineitem
where
        o_orderkey = l_orderkey
        and l_shipmode in ('MAIL', 'SHIP')
        and l_commitdate < l_receiptdate
        and l_shipdate < l_commitdate
        and l_receiptdate >= '1994-01-01'
        and l_receiptdate < dateadd(year, 1, '1994-01-01')
group by
        l_shipmode
order by
        l_shipmode;
