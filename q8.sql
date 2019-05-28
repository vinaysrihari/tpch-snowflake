/* TPC_H Q8: National Market Share Query

The market share for a given nation within a given region is defined as the
fraction of the revenue, the sum of [l_extendedprice * (1-l_discount)], from
the products of a specified type in that region that was supplied by suppliers
from the given nation. The query determines this for the years 1995 and 1996
presented in this order.
*/
alter session set query_tag='tpch_q8';
select
    o_year,
    round(sum(case
          when nation = 'BRAZIL' then volume
          else 0
          end) / sum(volume), 2) as mkt_share
from
    (
        select
            extract(year from o_orderdate) as o_year,
            l_extendedprice * (1 - l_discount) as volume,
            n2.n_name as nation
        from
            part,
            supplier,
            lineitem,
            orders,
            customer,
            nation n1,
            nation n2,
            region
        where
            p_partkey = l_partkey
            and s_suppkey = l_suppkey
            and l_orderkey = o_orderkey
            and o_custkey = c_custkey
            and c_nationkey = n1.n_nationkey
            and n1.n_regionkey = r_regionkey
            and r_name = 'AMERICA'
            and s_nationkey = n2.n_nationkey
            and o_orderdate between '1995-01-01' and '1996-12-31'
            and p_type = 'ECONOMY ANODIZED STEEL'
    ) as all_nations
group by
    o_year
order by
    o_year;
