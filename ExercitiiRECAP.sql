--1. Printr-un bloc PL/SQL, să se atribuie comision angajaților din departamentul al cărui id este citit de la tastatură. 
--Să se afișeze numărul de modificări totale efectuate.

Set serveroutput on;

DECLARE
    v_id angajati.id_departament%type:=&a;
 
BEGIN

        UPDATE angajati
        set comision=0.2
        where id_departament=v_id;
        
  
    DBMS_output.put_line(SQL%rowcount||' modificari');

END;
/
select*from angajati;

--cursori
--1. Construiți un bloc PL/SQL prin care să se afișeze informații despre angajații din orașul Toronto.
set SERVEROUTPUT on;
DECLARE
cursor c is select a.nume,a.salariul,a.id_departament from 
    angajati a join departamente d on a.id_departament=d.id_departament
    join locatii l on d.id_locatie=l.id_locatie
    where l.oras='Toronto';
v_nume angajati.nume%type;
v_sal angajati.salariul%type;
v_id_dep angajati.id_departament%type;
BEGIN

open c;
loop 
fetch c
into v_nume,v_sal,v_id_dep;
exit when c%notfound;

    DBMS_OUTPUT.put_line(v_nume||' '||v_sal||' '||v_id_dep);

end loop;
close c;
END;
/



set serveroutput on;
DECLARE
cursor c is 
select c.id_comanda,c.data,c.modalitate,count(rc.id_produs) nr_produse
from comenzi c join rand_comenzi rc
on c.id_comanda=rc.id_comanda
group by c.id_comanda,c.data,c.modalitate
order by count(rc.id_produs) desc
fetch first 3 rows only;

    
BEGIN

for v_com in c
loop
dbms_output.put_line(v_com.id_comanda||' '||v_com.data||' '||v_com.modalitate||' '||v_com.nr_produse);
end loop;

END;
/
set serveroutput on;

DECLARE

cursor c is
select d.id_departament,sum(a.salariul) salarii from departamente d 
join angajati a on a.id_departament=d.id_departament
group by d.id_departament;

BEGIN

for sal in c 
loop
    dbms_output.put_line(sal.id_departament||' '||sal.salarii);

end loop;

end;
