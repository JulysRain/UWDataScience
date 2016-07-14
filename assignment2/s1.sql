select *
from Frequency a, Frequency b
where a.term=b.term
drop table b
drop table a

create table a
(row_num int,
col_num int,
value int)

create table b
(row_num int,
col_num int,
value int)

insert into a (row_num, col_num, value)
values (0,2,4)
insert into a (row_num, col_num, value)
values (1,2,2)

delete from a

insert into b (row_num, col_num, value)
values (0,2,4)
insert into b (row_num, col_num, value)
values (1,2,2)
insert into b (row_num, col_num, value)
values (4,2)

select (rowid-1) as row_num, 2 as col_num*
from Frequency

select *, sum(a.count*b.count)
from Frequency a, Frequency b
where a.term = b.term
group by a.docid, b.term


SELECT a.row_num, b.col_num, a.value, b.value, SUM(a.value*b.value)
FROM a, b
WHERE a.col_num = b.col_num
GROUP BY a.row_num, b.value;