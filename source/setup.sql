CREATE OR REPLACE PACKAGE basic_uc AS
    FUNCTION get_num RETURN NUMBER;
    FUNCTION get_successful_submissions
        (p_email US_USER.U_EMAIL%TYPE)
    RETURN NUMBER;
    PROCEDURE submit_solution
        (p_exercise IN NUMBER,
        p_email IN US_USER.U_EMAIL%TYPE,
        p_public IN NUMBER(1),
        p_code IN VARCHAR2(2048));
    PROCEDURE log
        (p_message IN VARCHAR2(256));
END;
/

CREATE OR REPLACE PACKAGE BODY basic_uc AS

    FUNCTION create_user (p_username IN US_USER.U_USERNAME%TYPE, p_email IN US_USER.U_EMAIL%TYPE, p_password IN US_USER.U_PASSWORD%TYPE)
        RETURN BOOLEAN
    IS
    BEGIN
        insert into us_user (u_username, u_email, u_password, U_IS_MENTOR) values (p_username, p_email, p_password, 0);
        RETURN TRUE;
        EXCEPTION WHEN OTHERS THEN
            RETURN FALSE;
    END;

    FUNCTION get_num
        RETURN NUMBER
    IS
    BEGIN
        RETURN 123;
    end;

    FUNCTION check_if_submitted_exercise_successful
    (
        p_submitted_exercise SE_SUBMITTED_EXERCISE.SE_ID%TYPE
    )
    RETURN BOOLEAN
    AS
        v_successful BOOLEAN;
    BEGIN
        v_successful := TRUE;
        SELECT FALSE into v_successful FROM TR_TEST_RUN where TR_SE_EXERCISE = p_submitted_exercise AND TR_SUCCESS = 0;
        RETURN v_successful;
    END;

    FUNCTION get_successful_submissions
    (p_user US_USER.U_ID%TYPE)
    RETURN NUMBER
    AS
        v_successful_submissions NUMBER;
        CURSOR c1 IS SELECT SE_ID FROM SE_SUBMITTED_EXERCISE WHERE SE_US_USER = p_user;
    BEGIN
        for x in c1 loop
            IF check_if_submitted_exercise_successful(x) THEN
                v_successful_submissions := v_successful_submissions + 1;
            END IF;
            end loop;
        RETURN v_successful_submissions;
    END;

    PROCEDURE submit_solution
        (p_exercise IN NUMBER,
        p_email IN US_USER.U_EMAIL%TYPE,
        p_public IN NUMBER(1),
        p_code IN VARCHAR2(2048))
    AS
    BEGIN
    END;

    PROCEDURE log (
    p_message IN VARCHAR2(256))
    AS
        e_failed EXCEPTION;
    BEGIN
        INSERT INTO AL_AUDIT_LOG (AL_DATE, AL_INFO) VALUES (CURRENT_TIMESTAMP, p_message);
        IF SQL%NOTFOUND
            THEN RAISE e_failed;
        END IF;
    EXCEPTION
    WHEN e_failed THEN RAISE_APPLICATION_ERROR(-20001, 'Logging failed!');
    END;
END;
/

CREATE OR REPLACE PACKAGE advanced_uc AS
    PROCEDURE promote_mentor (
    p_email IN US_USER.U_EMAIL%TYPE,
    p_success OUT BOOLEAN);
    PROCEDURE setup_test_runs(p_submitted IN INTEGER);
END;
/

CREATE OR REPLACE PACKAGE BODY advanced_uc AS
    PROCEDURE promote_mentor (
    p_email IN US_USER.U_EMAIL%TYPE,
    p_success OUT INTEGER)
    AS
    BEGIN
        IF basic_uc.get_successful_submissions(p_email) >= 15
            THEN
                UPDATE US_USER SET U_IS_MENTOR = 1 WHERE U_EMAIL = p_email;
                basic_uc.log('User ''' || p_email || ''' is now a mentor!');
                p_success := 1;
            ELSE
                p_success := 0;
        END IF;
    END;

    PROCEDURE submit_solution(p_exercise IN NUMBER, p_user IN NUMBER, p_public IN NUMBER(1), p_code IN VARCHAR2(2048))
    AS
        v_unlocked_exercise_key NUMBER;
    BEGIN
        v_unlocked_exercise_key := 0;
        SELECT SE_UNLOCKED_EXERCISE_KEY INTO v_unlocked_exercise_key FROM SE_SUBMITTED_EXERCISE WHERE SE_US_USER = p_user AND SE_E_EXERCISE = p_exercise;
        if (v_unlocked_exercise_key = 0) THEN
            INSERT INTO SE_SUBMITTED_EXERCISE (SE_E_EXERCISE, SE_US_USER, SE_UNLOCKED_EXERCISE_KEY, SE_SUBMISSION_DATE, SE_PUBLIC, SE_CODE)
            values (p_exercise, p_user, 1, CURRENT_TIMESTAMP, p_public, p_code);
        ELSE
            UPDATE SE_SUBMITTED_EXERCISE SET SE_UNLOCKED_EXERCISE_KEY = v_unlocked_exercise_key + 1, SE_SUBMISSION_DATE = CURRENT_TIMESTAMP, SE_PUBLIC = p_public, SE_CODE = p_code WHERE SE_US_USER = p_user AND SE_E_EXERCISE = p_exercise;
        end if;
    END;
END;
/

CREATE OR REPLACE TRIGGER tr_submission_watcher
    AFTER INSERT ON SE_SUBMITTED_EXERCISE
BEGIN

end;

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

