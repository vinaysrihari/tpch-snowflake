/* TPC_H Q2: Minimum Cost Supplier Query

The Minimum Cost Supplier Query finds, in a given region, 
for each part of a certain type and size, the supplier who
can supply it at minimum cost. If several suppliers in that region 
offer the desired part type and size at the same (minimum) cost, 
the query lists the parts from suppliers with the 100 highest account 
balances. For each supplier, the query lists the supplier's account balance, 
name and nation; the part's number and manufacturer; the supplier's address, 
phone number and comment information.
*/
alter session set query_tag='tpch_q2';
select
        s_acctbal,
        s_name,
        n_name,
        p_partkey,
        p_mfgr,
        s_address,
        s_phone,
        s_comment
from
        part,
        supplier,
        partsupp,
        nation,
        region
where
        p_partkey = ps_partkey
        and s_suppkey = ps_suppkey
        and p_size = 15
        and p_type like '%BRASS'
        and s_nationkey = n_nationkey
        and n_regionkey = r_regionkey
        and r_name = 'EUROPE'
        and ps_supplycost = (
                select
                        min(ps_supplycost)
                from
                        partsupp,
                        supplier,
                        nation,
                        region
                where
                        p_partkey = ps_partkey
                        and s_suppkey = ps_suppkey
                        and s_nationkey = n_nationkey
                        and n_regionkey = r_regionkey
                        and r_name = 'EUROPE'
        )
order by
        s_acctbal desc,
        n_name,
        s_name,
        p_partkey
limit 100;
