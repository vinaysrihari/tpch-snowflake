/* TPC_H Q16: Parts/Supplier Relationship Query 

The Parts/Supplier Relationship Query counts the number of suppliers who can
supply parts that satisfy a particular customer's requirements. The customer
is interested in parts of eight different sizes as long as they are not of a
given type, not of a given brand, and not from a supplier who has had
complaints registered at the Better Business Bureau. Results must be presented
in descending count and ascending brand, type, and size. 
*/
alter session set query_tag='tpch_q16';
select
        p_brand,
        p_type,
        p_size,
        count(distinct ps_suppkey) as supplier_cnt
from
        partsupp,
        part
where
        p_partkey = ps_partkey
        and p_brand <> 'Brand#45'
        and p_type not like 'MEDIUM POLISHED%'
        and p_size in (49, 14, 23, 45, 19, 3, 36, 9)
        and ps_suppkey not in (
                select
                        s_suppkey
                from
                        supplier
                where
                        s_comment like '%Customer%Complaints%'
        )
group by
        p_brand,
        p_type,
        p_size
order by
        supplier_cnt desc,
        p_brand,
        p_type,
        p_size;
