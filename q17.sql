/* TPC_H Q17: Small-Quantity-Order Revenue Query

The Small-Quantity-Order Revenue Query considers parts of a given brand and
with a given container type and determines the average lineitem quantity of
such parts ordered for all orders (past and pending) in the 7-year database.
What would be the average yearly gross (undiscounted) loss in revenue if
orders for these parts with a quantity of less than 20% of this average were
no longer taken? 
*/
alter session set query_tag='tpch_q17';
select
        round(sum(l_extendedprice) / 7.0, 2) as avg_yearly
from
        lineitem,
        part
where
        p_partkey = l_partkey
        and p_brand = 'Brand#23'
        and p_container = 'MED BOX'
        and l_quantity < (
                select
                        0.2 * avg(l_quantity)
                from
                        lineitem
                where
                        l_partkey = p_partkey
        );
