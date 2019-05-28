/* TPC_H Q15: Top Supplier Query

The Top Supplier Query finds the supplier who contributed the most to the
overall revenue for parts shipped during a given quarter of a given year. In
case of a tie, the query lists all suppliers whose contribution was equal to
the maximum, presented in supplier number order.  
*/
alter session set query_tag='tpch_q15';
create or replace view revenue0 (supplier_no, total_revenue) as
        select
                l_suppkey,
                round(sum(l_extendedprice * (1 - l_discount)), 2)
        from
                lineitem
        where
                l_shipdate >= '1996-01-01'
                and l_shipdate < dateadd(month, 3, '1996-01-01')
        group by
                l_suppkey;

/* TPC_H Q15: Top Supplier Query

Here is the actual query.
*/
select
        s_suppkey,
        s_name,
        s_address,
        s_phone,
        total_revenue
from
        supplier,
        revenue0
where
        s_suppkey = supplier_no
        and total_revenue = (
                select max(total_revenue) from revenue0
        )
order by
        s_suppkey;
