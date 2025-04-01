--1. Intr-un bloc PL/SQL, folosind un cursor explicit, afisati informatii despre primii 5 salariati angajati (se va realiza filtrarea in functie de campul Data_Angajare).
SET SERVEROUTPUT ON
DECLARE
 cursor c is
 select nume,prenume, id_angajat,data_angajare,salariul
 from angajati 
 order by data_angajare
 fetch first 5 rows only;
 

 v c%rowtype;

BEGIN
   open c;
   loop
        fetch c into v ;
        exit when c%NOTFOUND;
        DBMS_OUTPUT.put_line(v.nume ||'  '||v.prenume||' angajat la data de '||v.data_angajare||' are salariul '||v.salariul);
    end loop;
    close c;

END;
/

--2. Intr-un bloc PL/SQL, folosind un cursor explicit, selectati numele, functia, data angajarii si vechimea salariatilor din tabela Angajati. 
--Parcurgeti fiecare rand al cursorului si, in cazul in care data angajarii depaseste 01-AUG-2016, afisati informatiile preluate.
SET SERVEROUTPUT ON
DECLARE
cursor c is 
select nume,id_functie,data_angajare,
extract(year from sysdate)-extract(year from data_angajare) as vechime
from angajati;

v c%rowtype;

BEGIN
    open c;
    loop 
        fetch c into v;
        exit when c%NOTFOUND;
         if v.data_angajare>'01-AUG-2016' 
            then
            DBMS_OUTPUT.put_line(v.nume ||' in functia '||v.id_functie||' angajat la data de '||v.data_angajare||' are vechimea de '||v.vechime||' ani');
        end if;
    end loop;
    close c;

END;
/
--3. Intr-un bloc PL/SQL, utilizand un cursor, afisati numarul de comenzi intermediate de fiecare angajat si, in functie de acesta, modificati procentul comisionului primit, astfel:

 --daca numarul de comenzi date este mai mic de 6, atunci comisionul devine 0.6

 --daca numarul comenzilor este intre 6 si 10, atunci comisionul devine 0.7

 --altfel, comisionul devine 0.8

--Încercați și o rezolvare alternativă care să utilizeze un cursor de tipul FOR UPDATE.


SET SERVEROUTPUT ON
DECLARE
cursor c is 
select a.id_angajat, count(c.id_comanda) as nr_comenzi,a.comision
from angajati a
join comenzi c
on c.id_angajat=a.id_angajat
group by a.id_angajat,a.comision;

v c%rowtype;
v_comision number;
v_case angajati.comision%type;
BEGIN
    open c;
    loop 
        fetch c into v;
        exit when c%NOTFOUND;
        v_case:= case 
         when  v.nr_comenzi<6
            then v_comision=0.6
         when v.nr_comenzi between 6 and 10
                then v_comision=0.7
         when v.nr_comenzi>10
                then v_comision=0.8
        end; 
        
       
       
        DBMS_OUTPUT.put_line(v.id_angajat ||' a efectuat '||v.nr_comenzi||' comenzi si are comisionul '||v.comision);
    
    end loop;
    close c;

END;
/
select comision from angajati;

--4. Sa se construiasca un bloc PL/SQL prin care sa se dubleze salariul angajatilor care au incheiat comenzi in anul 2009 
--si sa se pastreze numele lor intr-o tabela indexata. Sa se afiseze valorile elementelor colectiei.
SET SERVEROUTPUT ON
DECLARE
    TYPE colectie IS table of angajati.nume%type index by pls_integer;
    t colectie;

BEGIN

    update angajati 
    set salariul=salariul*2
    where id_angajat in(select id_angajat from comenzi where extract(year from data)=2009)
    returning nume bulk collect into t;--t=colectie,tabela indexata
    
    for i in t.first..t.last loop
        DBMS_OUTPUT.put_line(t(i));
     end loop;   
END;
/

--5. Sa se construiasca un bloc PL/SQL prin care sa se calculeze si sa se memoreze 
--intr-o tabela indexata salariul mediu al fiecarui departament. Afisati valorile elementelor colectiei.
Set serveroutput on;
DECLARE
    type rec is record ( v_dep departamente.denumire_departament%type,
                        v_sal_mediu angajati.salariul%type);
    type tabela_indexata is table of rec index by pls_integer;
    t tabela_indexata;
                              

BEGIN
    select denumire_departament,Avg(salariul)
    bulk collect into t
    from departamente join angajati using(id_departament)
    group by denumire_departament;
    
    for i in t.first..t.last loop
        DBMS_OUTPUT.put_line(t(i).v_dep||' '||round(t(i).v_sal_mediu));
     end loop;   

END;
/

--6. Sa se construiasca un bloc PL/SQL prin care sa se calculeze si sa se memoreze intr-o tabela indexata: pentru fiecare client (nume_client)
--valoarea totala a comenzilor efectuate.

--Sa se afiseze si numarul de elemente ale colectiei, dar si valorile elementelor acesteia.

Set serveroutput on;
DECLARE
    type rec is record ( nume_client clienti.nume_client%type,
                       val_comenzi_ef number(10));
    type tabela_indexata is table of rec index by pls_integer;
    t tabela_indexata;
                              

BEGIN
    select nume_client,sum(pret*cantitate)
    bulk collect into t
    from clienti join comenzi using(id_client)
      join rand_comenzi using(id_comanda)
    group by nume_client;
    
    for i in t.first..t.last loop
        DBMS_OUTPUT.put_line(t(i).nume_client||' '||round(t(i).val_comenzi_ef));
     end loop;   

END;
/

