/* TPC_H Q18: Large Volume Customer Query 

The Large Volume Customer Query finds a list of the top 100 customers who have
ever placed large quantity orders. The query lists the customer name, customer
key, the order key, date and total price and the quantity for the order. 
*/
alter session set query_tag='tpch_q18';
select
        c_name,
        c_custkey,
        o_orderkey,
        o_orderdate,
        o_totalprice,
        sum(l_quantity)
from
        customer,
        orders,
        lineitem
where
        o_orderkey in (
                select
                        l_orderkey
                from
                        lineitem
                group by
                        l_orderkey having
                                sum(l_quantity) > 300
        )
        and c_custkey = o_custkey
        and o_orderkey = l_orderkey
group by
        c_name,
        c_custkey,
        o_orderkey,
        o_orderdate,
        o_totalprice
order by
        o_totalprice desc,
        o_orderdate
limit 100;
