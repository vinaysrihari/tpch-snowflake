/* TPC_H Q13: Customer Distribution Query

This query determines the distribution of customers by the number of orders
they have made, including customers who have no record of orders, past or
present. It counts and reports how many customers have no orders, how many
have 1, 2, 3, etc. A check is made to ensure that the orders counted do not
fall into one of several special categories of orders. Special categories are
identified in the order comment column by looking for a particular pattern.
*/
alter session set query_tag='tpch_q13';
select
    c_count,
    count(*) as custdist
from
    (
        select
            c_custkey,
            count(o_orderkey)
        from
            customer left outer join orders on
                c_custkey = o_custkey
                and o_comment not like '%special%requests%'
        group by
            c_custkey
    ) as c_orders (c_custkey, c_count)
group by
    c_count
order by
    custdist desc,
    c_count desc;
