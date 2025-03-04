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
 
 
 
