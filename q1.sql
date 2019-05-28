/* TPC_H Q1: Pricing Summary Report Query

The Pricing Summary Report Query provides a summary pricing report for all
lineitems shipped as of a given date. The date is within 60 - 120 days of the
greatest ship date contained in the database. The query lists totals for
extended price, discounted extended price, discounted extended price plus tax,
average quantity, average extended price, and average discount. These
aggregates are grouped by RETURNFLAG and LINESTATUS, and listed in ascending
order of RETURNFLAG and LINESTATUS. A count of the number of lineitems in each
group is included.
*/
alter session set query_tag='tpch_q1';
select
        l_returnflag, l_linestatus,
        round(sum(l_quantity),2) as sum_qty,
        round(sum(l_extendedprice),2) as sum_base_price,
        round(sum(l_extendedprice * (1 - l_discount)),2) as sum_disc_price,
        round(sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)),2) as sum_charge,
        round(avg(l_quantity),2) as avg_qty,
        round(avg(l_extendedprice),2) as avg_price,
        round(avg(l_discount),2) as avg_disc,
        count(*) as count_order
from
        lineitem
where
        l_shipdate <= dateadd(dd, -90, '1998-12-01')
group by
        l_returnflag,
        l_linestatus
order by
        l_returnflag,
        l_linestatus;
