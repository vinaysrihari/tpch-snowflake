/* TPC_H Q6: Forecasting Revenue Change Query

The Forecasting Revenue Change Query considers all the lineitems shipped in a
given year with discounts between DISCOUNT-0.01 and DISCOUNT+0.01. The query
lists the amount by which the total revenue would have increased if these
discounts had been eliminated for lineitems with l_quantity less than
quantity. Note that the potential revenue increase is equal to the sum of
[l_extendedprice * l_discount] for all lineitems with discounts and quantities
in the qualifying range.
*/
alter session set query_tag='tpch_q6';
select
    round(sum(l_extendedprice * l_discount),2) as revenue
from
    lineitem
where
    l_shipdate >= '1994-01-01'
    and l_shipdate < dateadd(year, 1, '1994-01-01')
    and l_discount between 0.06 - 0.01 and 0.06 + 0.01
    and l_quantity < 24;
