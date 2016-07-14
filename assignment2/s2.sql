drop table b

create table similarityTab
(aDoc varchar(200),
bDoc varchar(200),
simVal int)

Insert into similarityTab
select a.docid aDoc, b.docid bDoc, sum(a.count*b.count) simVal
from Frequency a, Frequency b
where a.term = b.term and aDoc<bDoc
group by a.docid

select *
from similarityTab
where aDoc = "10080_txt_crude"

select sum(m.count*n.count)
from (select *
from Frequency
where docid="10080_txt_crude" ) m,
(select *
from Frequency
where docid="17035_txt_earn") n
where m.term = n.term
group by m.docid

Create view freq as
SELECT * FROM frequency
UNION
SELECT 'q' as docid, 'washington' as term, 1 as count 
UNION
SELECT 'q' as docid, 'taxes' as term, 1 as count
UNION 
SELECT 'q' as docid, 'treasury' as term, 1 as count;

select sum(freq.count*q.count) great
from freq,
(select *
from freq
where docid = 'q')q
where freq.term = q.term
group by freq.docid
order by great desc;