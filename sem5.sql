--1. Creaţi un bloc PL/SQL pentru a selecta codul și data de încheiere a comenzilor încheiate într-un an introdus de la tastatură 
--(prin comandă SELECT simplă, fără să utilizați un cursor explicit).

--dacă interogarea returnează mai mult de o valoare pentru codul comenzii, tratați excepția cu o rutină de tratare corespunzătoare și afișați mesajul “Atenţie! In anul yyyy s-au încheiat mai multe comenzi!”;
--dacă interogarea nu returnează nicio valoare pentru codul comenzii, tratați excepția cu o rutină de tratare corespunzătoare și afișați mesajul “Atenţie! In anul yyyy nu s-au încheiat comenzi!”;
--dacă se returnează o singură linie, afișați codul și data comenzii;
--tratați orice altă excepție cu o rutină de tratare corespunzătoare și afișați mesajul “A apărut o altă excepție!”.
--testati cu anul 2015 (o singura comanda) => se face afisarea din zona executabila (comanda SELECT intoarce un singur rezultat)
--testati cu anul 2019 (mai multe comenzi) => SELECT returneaza mai multe linii => TOO_MANY_ROWS
--testati cu anul 2000 (nicio comanda) => SELECT nu returneaza nimic => NO_DATA_FOUND


SET SERVEROUTPUT ON
DECLARE

 v_an number:=&a;
 v_data comenzi.data%type;
 v_id comenzi.id_comanda%type;
 prea_multe exception;
 pragma EXCEPTION_INIT(prea_multe,-01422); -- cod eroare
 
BEGIN

  select id_comanda,data 
  into v_id,v_data
  from comenzi
  where extract(year from data)=v_an;
  DBMS_OUTPUT.put_line(v_id||' '||v_data);
  
EXCEPTION
    when NO_DATA_FOUND then  DBMS_OUTPUT.put_line('Nu exista comenzi in anul '||v_an);
    when prea_multe then DBMS_OUTPUT.put_line('Prea multe comenzi in anul '||v_an);
                    for v in (select id_comanda,data 
                    into v_id,v_data
                    from comenzi
                    where extract(year from data)=v_an)
                    loop
                    DBMS_OUTPUT.put_line(v_id||' '||v_data);
                    end loop;
                    
                    

END;
/
SET SERVEROUTPUT ON
--2. Creaţi un bloc PL/SQL prin care se dublează preţul produsului (pret_lista) al cărui cod este citit de la tastatură.
--În cazul în care acesta nu există (comanda UPDATE nu realizează nicio modificare) se va invoca o excepție. 
--Tratați excepția prin afișarea unui mesaj.
--testati cu id produs 3061 pentru a obtine modificari prin UPDATE
--=> se produce modificarea si se face afisarea din zona executabila
--testati cu id produs 100 pentru a nu obtine modificari prin UPDATE
--=> se invoca exceptia definita de utilizator => se afiseaza mesajul din Exception

DECLARE
v_id produse.id_produs%type:=&p;
produs_inexistent exception;
BEGIN
update produse 
set pret_lista=pret_lista*2
where id_produs=v_id;

  

if SQL%NOTFOUND then 
    Raise produs_inexistent;
else
DBMS_OUTPUT.put_line('Pretul produsului a fost updatat');
end if;

EXCEPTION
when produs_inexistent then
    DBMS_OUTPUT.put_line('Produsul nu exista ');
                    
                   
END;
/
SET SERVEROUTPUT ON
--3. Într-un bloc PL/SQL citiți de la tastatură identificatorul unui produs. Afișați denumirea produsului care are acel cod. De asemenea, calculați cantitatea totală comandată din acel produs.

--afișați denumirea produsului;
--dacă produsul nu există, tratați excepția cu o rutină de tratare corespunzătoare;
--dacă produsul nu a fost comandat, invocați o excepție, care se va trata corespunzător;
--dacă produsul există și a fost comandat, afișați cantitatea totală comandată;
--tratați orice altă excepție cu o rutină de tratare corespunzătoare.
--testati cu id produs 3061 (nu a fost comandat) => se invoca exceptia definita de utilizator => se afiseaza mesajul din Exception
--testati cu id produs 2311 (a fost comandat) => se afiseaza mesajul din zona executabila
--testati cu id produs 100 (nu exista) => NO_DATA_FOUND
DECLARE
v_id produse.id_produs%type:=&p;
v_nume produse.denumire_produs%type;
v_suma rand_comenzi.cantitate%type; 
produs_necomandat exception;

BEGIN
select denumire_produs
into v_nume
from produse
where id_produs=v_id;
    DBMS_OUTPUT.put_line(v_nume);

    select sum(cantitate) into v_suma
    from rand_comenzi
    where id_produs=v_id;

    if v_suma is null then
        raise produs_necomandat;
    else 
        DBMS_OUTPUT.put_line(v_suma);

    end if;

EXCEPTION

when NO_DATA_FOUND then
    DBMS_OUTPUT.put_line('Produsul nu exista ');
when produs_necomandat then
    DBMS_OUTPUT.put_line('Produsul exista dar n a fost comandat ');                   
                   
END;
/

--4. Într-un bloc PL/SQL utilizați un cursor parametrizat pentru a prelua numele, salariul și vechimea angajaților dintr-un departament furnizat drept parametru.

--deschideți cursorul prin indicarea ca parametru a unei variabile de substituție, a cărei valoare să fie citită de la tastatură;
--parcurgeți cursorul și afișați informațiile solicitate pentru acei angajați care fac parte din departamentul indicat;
--afișați numărul total de angajați parcurși;
--în cazul în care nu există departamentul indicat, se va invoca o excepție, care se va trata corespunzător;
--în cazul în care nu există angajați în departamentul indicat, se va invoca o excepție, care se va trata corespunzător.
--testati cu id departament 7 pentru a verifica lipsa departamentului  => se invocă excepție
--testati cu id departament 210 pentru a nu obtine niciun rezultat  => SELECT nu returneaza nimic, deci cursorul indica o zona goala de memorie => nu se face nicio parcurgere
--testati cu id departament 50 pentru a obtine mai multe rezultate => se efectueaza parcurgerile asupra setului de date adus in memorie

set SERVEROUTPUT on
 declare  
 cursor c (p number) is select nume,salariul,extract(year from sysdate)-extract(year from data_angajare)
                                            from angajati
                                            where id_departament=p;
 v_id number:=&d;
 v_nume angajati.nume%type;
 v_sal number;
 v_vechime number;
 v_total number;
 fara_angajati exception;
 
 begin
 select id_departament into x
 from departamente
 where id_departament=v_id;
 
 for v in c(v_id) loop
    i:=i+1;
 end loop;
 if(i=0) then
    raise fara_angajati;
    else DBMS_OUTPUT.PUT_LINE('Nume: ' || v_nume || ', Salariu: ' || v_sal || ', Vechime: ' || v_vechime || ' ani.');
 end if;     
 
 
 exception
 when fara_angajati then DBMS_OUTPUT.PUT_LINE('Nu exista angajati in departament');
 end;

 /
 
 


