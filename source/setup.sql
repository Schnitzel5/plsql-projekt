CREATE OR REPLACE PACKAGE basic_uc AS
    FUNCTION get_num RETURN NUMBER;
    PROCEDURE create_user (
    p_email IN US_USER.U_EMAIL%TYPE,
    p_name IN US_USER.U_USERNAME%TYPE,
    p_password IN US_USER.U_PASSWORD%TYPE);
    PROCEDURE promote_mentor (
    p_email IN US_USER.U_EMAIL%TYPE,
    p_success OUT BOOLEAN);
END;
/

CREATE OR REPLACE PACKAGE BODY basic_uc AS
    FUNCTION get_num
        RETURN NUMBER
    IS
    BEGIN
        RETURN 123;
    end;
    PROCEDURE create_user (
    p_email IN US_USER.U_EMAIL%TYPE,
    p_name IN US_USER.U_USERNAME%TYPE,
    p_password IN US_USER.U_PASSWORD%TYPE)
    AS
    BEGIN
    END;
    PROCEDURE promote_mentor (
    p_email IN US_USER.U_EMAIL%TYPE,
    p_success OUT BOOLEAN)
    AS
    BEGIN
    END;
END;
/

CREATE OR REPLACE PACKAGE advanced_uc AS
    PROCEDURE setup_test_runs(p_submitted IN INTEGER);
END;
/

CREATE OR REPLACE PACKAGE BODY advanced_uc AS

END;
/

-- 12 Use Cases -
-- einfache -> User anlegen,
-- Exercise erstellen und Tests hinzufügen (Exceptions,),
-- check ob submitted exercise erfolgreich ist
-- komplexe ->
-- test runs für jeden te_test inserten (Exceptions,) und einfache Funktionen (oben) wiederverwenden
-- promote user to mentor wenn user schon mind. 15 erfolgreiche submitted exercises hat
-- procedure für Ausgabe von alle Exercises (Track als Parameter mit Exceptions) mit Pagination
-- function für check ob der User absolved concepts für die required concepts vorhanden sind
-- procedure für die Einreichung von einem Exercise (submitted_exercise)
-- -> se_unlocked_exercise_key ist die Anzahl der eingereichten submitted_exercise + 1
-- logging (al_audit_log) - alles mögliche bei jedem Function/Procedure loggen
-- trigger (erstellt automatisch tr_test_runs für jeden te_test zum verknüpften e_exercise,
-- wenn se_submitted_exercise inserted wird)

