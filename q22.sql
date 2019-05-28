/* TPC_H Q22: Global Sales Opportunity Query

This query counts how many customers within a specific range of country codes
have not placed orders for 7 years but who have a greater than average
positive account balance. It also reflects the magnitude of that balance.
Country code is defined as the first two characters of c_phone.  
*/
alter session set query_tag='tpch_q22';
select
        cntrycode,
        count(*) as numcust,
        round(sum(c_acctbal),2) as totacctbal
from
        (
                select
                        substring(c_phone,1,2) as cntrycode,
                        c_acctbal
                from
                        customer
                where
                        substring(c_phone,1,2) in
                                ('13', '31', '23', '29', '30', '18', '17')
                        and c_acctbal > (
                                select
                                        avg(c_acctbal)
                                from
                                        customer
                                where
                                        c_acctbal > 0.00
                                        and substring(c_phone,1,2) in
                                ('13', '31', '23', '29', '30', '18', '17')
                        )
                        and not exists (
                                select
                                        *
                                from
                                        orders
                                where
                                        o_custkey = c_custkey
                        )
        ) as custsale
group by
        cntrycode
order by
        cntrycode;
