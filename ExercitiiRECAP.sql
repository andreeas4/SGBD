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

