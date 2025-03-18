-- 1.Printr-un bloc PL/SQL, să se atribuie comision angajaților din departamentul al cărui id este citit de la tastatură. 
--Să se afișeze numărul de modificări totale efectuate.

SET SERVEROUTPUT ON
DECLARE
v_id angajati.id_departament%type:=&a;
v number;
BEGIN
    select count(id_departament) into v
    from departamente
    where id_departament=v_id;--intoarce 0 sau 1
    --are functie buleana de verificare
    
    if v=0 then
     DBMS_OUTPUT.put_line('fara modificari');
    else
        update angajati
        set comision=0.1
        where id_departament=&id;
    
        if sql%found then
        --atributele cursorului implicit
        DBMS_OUTPUT.put_line(sql%rowcount);
        else 
        DBMS_OUTPUT.put_line('fara modificari');
        end if;
    end if;

END;
/

-- 2.  Construiți un bloc PL/SQL prin care să se afișeze informații despre angajații din orașul Toronto.

SET SERVEROUTPUT ON
DECLARE
 cursor c is
 select nume,salariul
 from angajati join departamente using(id_departament)
 join locatii using(id_locatie)
 where oras='Toronto';
 
 --v_nume angajati.nume%type;
 --v_salariul angajati.salariul%type;
 v c%rowtype;

BEGIN
   open c;
   loop
        fetch c into v ;
        exit when c%NOTFOUND;
        DBMS_OUTPUT.put_line(v.nume ||'  '||v.salariul);
    end loop;
    close c;

END;
/

--3.Construiți un bloc PL/SQL prin care să se afișeze primele 3 comenzi care au cele mai multe produse comandate.

SET SERVEROUTPUT ON

DECLARE

 cursor c is
 select c.id_comanda,count(rc.id_produs)as nr_produse ,c.data
 from comenzi c
 join rand_comenzi rc 
 on rc.id_comanda=c.id_comanda
 group by c.id_comanda,c.data
 order by count(rc.id_produs) desc
 fetch first 3 rows only;
 
 v c%rowtype;

BEGIN
   open c;
   loop
        fetch c into v ;
        exit when c%NOTFOUND;
        DBMS_OUTPUT.put_line(v.id_comanda||'  '||v.nr_produse);
    end loop;
    close c;

END;
/

--4.Construiți un bloc PL/SQL prin care să se afișeze, pentru fiecare departament, valoarea totală a salariilor plătite angajaților.


SET SERVEROUTPUT ON

DECLARE

    cursor c is
        select id_departament,denumire_departament as den,sum(salariul)as val_tot from angajati
        join departamente using(id_departament)
        group by id_departament,denumire_departament;
 


BEGIN
   FOR v in c loop      --v de tip compus
    DBMS_OUTPUT.put_line(v.den||'  '||v.val_tot);
   end loop;

END;
/

--5. Construiți un bloc PL/SQL prin care să se afișeze informații despre angajați, precum și numărul de comenzi intermediate de fiecare.


SET SERVEROUTPUT ON

DECLARE

    cursor c is
        select nume,salariul,count(id_comanda)as nr_comenzi
        from angajati join comenzi using(id_angajat)
        group by nume,salariul;
 


BEGIN
   FOR v in c loop      --v de tip compus
    DBMS_OUTPUT.put_line(v.nume||' cu salariul '||v.salariul ||' a intermediat '||v.nr_comenzi||' comenzi');
   end loop;

END;
/

-- 6.Construiți un bloc PL/SQL prin care să se afișeze pentru fiecare departament (id și nume) informații despre angajații aferenți (id, nume, salariu). Să se afișeze la nivelul fiecărui departament și salariul total plătit.
--Informațiile vor fi afișate în următoarea manieră:

--*departament A
--******angajat 1
--******angajat 2
--Total salarii A: ...

--* departament B
--******angajat 5
--******angajat 6
--******angajat 7
--Total salarii B: ...


SET SERVEROUTPUT ON

DECLARE
--2 cursori
    cursor d is
         select id_departament, denumire_departament
            from departamente
            where id_departament in(select id_departament from angajati);
       
    cursor a(p number) is 
        select id_angajat,nume,id_departament from angajati
        where id_departament=p;
        
 


BEGIN
   FOR v in d loop      --v de tip compus
    DBMS_OUTPUT.put_line('*'||v.denumire_departament);
        FOR w in a(v.id_departament) loop               -- p=v.id_departament
            DBMS_OUTPUT.put_line('***'||w.nume);
          
        end loop;
        
   end loop;
--loop in loop
END;
/











