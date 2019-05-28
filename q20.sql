/* TPC_H Q20: Potential Part Promotion Query

The Potential Part Promotion query identifies suppliers who have an excess of
a given part available; an excess is defined to be more than 50% of the parts
like the given part that the supplier shipped in a given year for a given
nation. Only parts whose names share a certain naming convention are
considered. 
*/
alter session set query_tag='tpch_q20';
select
        s_name,
        s_address
from
        supplier,
        nation
where
        s_suppkey in (
                select
                        ps_suppkey
                from
                        partsupp
                where
                        ps_partkey in (
                                select
                                        p_partkey
                                from
                                        part
                                where
                                        p_name like 'forest%'
                        )
                        and ps_availqty > (
                                select
                                        0.5 * sum(l_quantity)
                                from
                                        lineitem
                                where
                                        l_partkey = ps_partkey
                                        and l_suppkey = ps_suppkey
                                        and l_shipdate >= '1994-01-01'
                                        and l_shipdate < dateadd(year, 1, '1994-01-01')
                        )
        )
        and s_nationkey = n_nationkey
        and n_name = 'CANADA'
order by
        s_name;
