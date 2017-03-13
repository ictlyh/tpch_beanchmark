-- the query
insert overwrite table q5_local_supplier_volume 
select 
  n_name, sum(l_extendedprice * (1 - l_discount)) as revenue 
from
  customer c join
    ( select n_name, l_extendedprice, l_discount, s_nationkey, o_custkey from orders o join
      ( select n_name, l_extendedprice, l_discount, l_orderkey, s_nationkey from lineitem l join
        ( select n_name, s_suppkey, s_nationkey from supplier s join
          ( select n_name, n_nationkey 
            from nation n join region r 
            on n.n_regionkey = r.r_regionkey and r.r_name = 'ASIA'
          ) n1 on s.s_nationkey = n1.n_nationkey
        ) s1 on l.l_suppkey = s1.s_suppkey
      ) l1 on l1.l_orderkey = o.o_orderkey and o.o_orderdate >= '1994-01-01' 
              and o.o_orderdate < '1995-01-01'
) o1 
on c.c_nationkey = o1.s_nationkey and c.c_custkey = o1.o_custkey
group by n_name 
order by revenue desc
LIMIT 2147483647;
