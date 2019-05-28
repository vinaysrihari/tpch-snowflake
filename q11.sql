/* TPC_H Q11: Important Stock Identification Query

The Important Stock Identification Query finds, from scanning the available
stock of suppliers in a given nation, all the parts that represent a
significant percentage of the total value of all available parts. The query
displays the part number and the value of those parts in descending order of
value.
*/
alter session set query_tag='tpch_q11';
select
        ps_partkey,
        round(sum(ps_supplycost * ps_availqty),2) as value
from
        partsupp,
        supplier,
        nation
where
        ps_suppkey = s_suppkey
        and s_nationkey = n_nationkey
        and n_name = 'GERMANY'
group by
        ps_partkey having
                sum(ps_supplycost * ps_availqty) > (
                        select
                                sum(ps_supplycost * ps_availqty) * 0.0001
                        from
                                partsupp,
                                supplier,
                                nation
                        where
                                ps_suppkey = s_suppkey
                                and s_nationkey = n_nationkey
                                and n_name = 'GERMANY'
                )
order by
        value desc;
