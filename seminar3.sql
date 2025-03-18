--seminar 1
set SERVEROUTPUT on
accept a Prompt 'Introduceti a:'
var g number
declare
    v_nr number(6,2);
    v_data DATE:=SYSDATE;
    v_tsmst TIMESTAMP:=SYSTIMESTAMP;
    v_text VARCHAR2(20):='&a';
 begin
    v_nr:=123.456;
    DBMS_OUTPUT.put_line(v_nr);
    DBMS_OUTPUT.put_line(to_char(v_data,'DD/MM/YYYY'));
    DBMS_OUTPUT.put_line(substr(v_text,1,3));
    :g:=v_nr+2;
    DBMS_OUTPUT.put_line(:g);
    
 end;
 print g
 
 select * from angajati where id_angajat=round(:g);
 
 --sa se afiseze numele,venitul total,si vechimea angajatului citit de la tastatura
 
 declare 
 v_id number(4,0):=&b;
 v_nume angajati.nume%type;
 v_vechime number;
 v_venit number;
 begin
 select nume,salariul+salariul*nvl(comision,0),
 extract(year from sysdate)-extract(year from data_angajare)
 into v_nume,v_venit,v_vechime
 from angajati where id_angajat=v_id;
 DBMS_OUTPUT.put_line('Angajatul '||v_id||' este '||v_nume||' cu vechimea '||v_vechime);
 
 end;
 /
 
 --sa se mareasca salariul angajatului citi de la tastatura urm pasii
 --se preiau si se afiseaza info despre angajat
 --se mareste salariul cu 100 intr o variabia
 --se modifica salariul angajatului
 --se oreia si se afiseaza salariul final dupa modificare
 
 declare
 v_id number(4,0):=&b;
 v_nume angajati.nume%type;
 v_salariul angajati.salariul%type;
 
 begin
 select nume,salariul
 into v_nume,v_salariul
 from angajati where id_angajat=v_id;
 
 v_salariul:=v_salariul+100;
 update angajati 
 set salariul=v_salariul
 where id_angajat=v_id
 returning salariul into v_salariul;
 
 DBMS_OUTPUT.put_line('Angajatul '||v_id||' este '||v_nume||' cu salariul '||v_salariul);
 
 
 end;
 
 

--seminar 2

--1. Într-un bloc PL/SQL să se modifice salariul angajatului citit de la tastatură în funcție de numărul de comenzi pe care acesta le-a intermediat. Urmați pașii:
 --inițial, se vor afișa numele și salariul angajatului citit de la tastatură
-- se va calcula și se va afișa numărul de comenzi intermediate de angajatul respectiv
 --în cazul în care acesta este între 3 și 7, salariul angajatului va crește cu 10%
 --în cazul în care acesta este mai mare decât 7, salariul angajatului va crește cu 20%
-- altfel, salariul angajatului rămâne nemodificat
 --se va opera modificarea salariului la nivelul tabelei
 --la final, se va afișa salariul nou al angajatului respectiv
 
set SERVEROUTPUT on
accept b Prompt 'Introduceti angajat:'
var g number
 declare 
 
 v_id number(4,0):=&b;
 v_nume angajati.nume%type;
 v_salariul number;
 v_nr_comenzi number;
 
 begin
 
 select a.nume,a.salariul,count(c.id_comanda)
 into v_nume,v_salariul,v_nr_comenzi
 from angajati a join comenzi c
 on a.id_angajat=c.id_angajat
 where a.id_angajat=v_id
 group by a.nume,a.salariul;
 DBMS_OUTPUT.put_line('Angajatul '||v_id||' este '||v_nume|| ' cu salariul ' ||v_salariul);
 DBMS_OUTPUT.put_line('Si a efectuat ' ||v_nr_comenzi||' de comenzi');
 
 if v_nr_comenzi between 3 and 7 then
 v_salariul:=v_salariul+v_salariul*0.1;
elsif v_nr_comenzi>7 then v_salariul:=1.2;
else v_salariul:=v_salariul;
end if;

 update angajati
 set salariul=v_salariul
 where id_angajat=v_id
 returning salariul into v_salariul;
 
 DBMS_OUTPUT.put_line('Salariul final ' ||v_salariul);
 
 end;
 
 
 -- 2. Într-un bloc PL/SQL să se parcurgă toți angajații cu id_angajat de la 100 la 120, afișând numele, salariul și vechimea.
 set SERVEROUTPUT on
 declare  
 v_id number;
 v_nume angajati.nume%type;
 v_sal number;
 v_vechime number;
 begin
 
 for i in 100..120
 loop 
 select nume,salariul,extract(year from sysdate)-extract(year from data_angajare)
 into v_nume,v_sal,v_vechime
 from angajati
 where id_angajat=i;
 DBMS_OUTPUT.put_line('Angajatul '||i||' este '||v_nume||' cu vechimea '||v_vechime||' si salariul '||v_sal);
 end loop;
 
 end;
 
 
 declare  
 i number:=100;
 v_nume angajati.nume%type;
 v_sal number;

 begin
 
 while i<=120
    loop
    select nume,salariul
    into v_nume,v_sal
    from angajati
    where id_angajat=i;
   DBMS_OUTPUT.put_line('Angajatul '||i||' este '||v_nume||'cu salariul '||v_sal);
   i:=i+1;
 end loop;
 end;
 set serveroutput on
declare
    v_sal number;
    v_nume angajati.nume%type;
    v_vechime number(2);
    i number :=100;
begin
    loop select nume,salariul,(sysdate-data_angajare)/365
         into v_nume,v_sal,v_vechime
        from angajati where id_angajat=i;
        dbms_output.put_line('Angajatul '||i|| ' este '||v_nume||' initial '||v_sal|| ' si vechimea de '||v_vechime||' ani.');
        i := i+1;
        exit when i>120;
        end loop;
end;
/
 --3. Într-un bloc PL/SQL să se parcurgă toți angajații, folosind pe rând structurile: FOR-LOOP, WHILE-LOOP, LOOP-EXIT WHEN
 
  declare  
 
 v_nume angajati.nume%type;
 v_sal number;
 v_min angajati.id_angajat%type;
 v_max v_min%type;
 v_test number;
 begin
 
 select max(id_angajat),min(id_angajat)
 into v_max,v_min
 from angajati;
  
  for i in v_min..v_max
loop 
    select count(id_angajat) into v_test
    from angajati
    where id_angajat=i;
    
    if v_test=1 then--angajatul exista
    select nume,salariul
    into v_nume,v_sal
     from angajati
    where id_angajat=i;
    DBMS_OUTPUT.put_line('Angajatul '||i||' este '||v_nume||' salariul '||v_sal);
    else 
     DBMS_OUTPUT.put_line('nu exista angajatul');
     end if;
 end loop;
 
 end;
 
 
 --4. Printr-o comandă SQL simplă, să se șteargă angajatul cu id_angajat 150
 
 delete from angajati 
 where id_angajat=150;

