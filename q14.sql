/* TPC_H Q14: Promotion Effect Query

The Promotion Effect Query determines what percentage of the revenue in a
given year and month was derived from promotional parts. The query considers
only parts actually shipped in that month and gives the percentage. Revenue is
defined as (l_extendedprice * (1-l_discount)). 
*/
alter session set query_tag='tpch_q14';
select
        round(100.00 * sum(case
                when p_type like 'PROMO%'
                        then l_extendedprice * (1 - l_discount)
                else 0
        end) / sum(l_extendedprice * (1 - l_discount)), 2) as promo_revenue
from
        lineitem,
        part
where
        l_partkey = p_partkey
        and l_shipdate >= '1995-09-01'
        and l_shipdate < dateadd(month, 1, '1995-09-01');
