CREATE OR REPLACE TYPE ARRAY_TEST is table of varchar2(2048);

CREATE OR REPLACE PACKAGE basic_uc AS
    FUNCTION create_user
        (p_username IN US_USER.U_USERNAME%TYPE,
        p_email IN US_USER.U_EMAIL%TYPE,
        p_password IN US_USER.U_PASSWORD%TYPE)
        RETURN BOOLEAN;
    FUNCTION check_if_submitted_exercise_successful
        (p_submitted_exercise SE_SUBMITTED_EXERCISE.SE_ID%TYPE)
        RETURN BOOLEAN;
    FUNCTION get_successful_submissions
        (p_user US_USER.U_ID%TYPE)
    RETURN NUMBER;
    PROCEDURE submit_solution
        (p_exercise IN NUMBER,
        p_user IN NUMBER,
        p_public IN NUMBER,
        p_code IN VARCHAR2);
    PROCEDURE create_exercise
        (p_name IN VARCHAR2,
        p_description IN VARCHAR2,
        p_difficulty IN NUMBER,
        p_track IN NUMBER);
    PROCEDURE create_test
        (p_exercise IN NUMBER,
        p_tests IN ARRAY_TEST);
    PROCEDURE log
        (p_message IN VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY basic_uc AS

    FUNCTION create_user
    (p_username US_USER.U_USERNAME%TYPE,
    p_email US_USER.U_EMAIL%TYPE,
    p_password US_USER.U_PASSWORD%TYPE)
        RETURN BOOLEAN
    IS
    BEGIN
        insert into us_user (u_username, u_email, u_password, U_IS_MENTOR) values (p_username, p_email, p_password, 0);
        log('User "' || p_email || '" created!');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN RETURN FALSE;
    END;

    FUNCTION check_if_submitted_exercise_successful
    (
        p_submitted_exercise SE_SUBMITTED_EXERCISE.SE_ID%TYPE
    )
    RETURN BOOLEAN
    AS
        v_successful BOOLEAN;
        v_value NUMBER;
    BEGIN
        v_successful := TRUE;
        v_value := 0;
        SELECT 1 into v_value FROM TR_TEST_RUN where TR_SE_EXERCISE = p_submitted_exercise AND TR_SUCCESS = 0;
        if v_value = 1 THEN
            v_successful := FALSE;
        end if;
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
            IF check_if_submitted_exercise_successful(x.SE_ID) THEN
                v_successful_submissions := v_successful_submissions + 1;
            END IF;
            end loop;
        RETURN v_successful_submissions;
    END;

    PROCEDURE submit_solution
    (p_exercise IN NUMBER,
    p_user IN NUMBER,
    p_public IN NUMBER,
    p_code IN VARCHAR2)
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

    PROCEDURE create_exercise
    (p_name IN VARCHAR2,
    p_description IN VARCHAR2,
    p_difficulty IN NUMBER,
    p_track IN NUMBER)
    AS
        v_exists BOOLEAN;
        v_value NUMBER;
        e_already_exists EXCEPTION;
    BEGIN
        v_exists := FALSE;
        v_value := 0;
        SELECT 1 INTO v_value FROM E_EXERCISE WHERE E_NAME = p_name;
        if (v_value = 1) THEN
            v_exists := TRUE;
        END IF;
        if(v_exists) THEN
            RAISE e_already_exists;
        END IF;
        INSERT INTO E_EXERCISE (E_NAME, E_DESCRIPTION, E_D_DIFFICULTY, E_TR_TRACK) VALUES (p_name, p_description, p_difficulty, p_track);
        log('New exercise "' || p_name || '" created!');
    EXCEPTION
        WHEN e_already_exists THEN RAISE_APPLICATION_ERROR(-20001, 'Exercise already exists! Choose another name!');
        WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20002, 'Something went wrong!');
    END;

    PROCEDURE create_test
    (p_exercise IN NUMBER,
    p_tests IN ARRAY_TEST)
    AS
        v_exists BOOLEAN;
        v_value NUMBER;
        e_already_exists EXCEPTION;
    BEGIN
        FOR idx IN 1..p_tests.count LOOP
            v_value := 0;
            v_exists := FALSE;
            SELECT 1 INTO v_value FROM TE_TEST WHERE TE_CODE = p_tests(idx) AND TE_E_EXERCISE = p_exercise;
            if(v_value = 1) THEN
                v_exists := TRUE;
            END IF;
            IF (v_exists) THEN
                RAISE e_already_exists;
            END IF;
            INSERT INTO TE_TEST (TE_CODE, TE_E_EXERCISE) VALUES (p_tests(idx), p_exercise);
        end loop;
    EXCEPTION
        WHEN e_already_exists THEN RAISE_APPLICATION_ERROR(-20001, 'Test already exists! Why are you trying to create it again?');
        WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20002, 'Something went wrong!');
    END;

    PROCEDURE log
    (
    p_message IN VARCHAR2)
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
    PROCEDURE promote_mentor
        (p_email IN US_USER.U_EMAIL%TYPE,
        p_success OUT INTEGER);
    PROCEDURE setup_test_runs
        (p_submitted IN INTEGER);
    FUNCTION check_if_user_absolved_concepts
        (p_user US_USER.U_ID%TYPE, p_exercise in NUMBER)
    RETURN BOOLEAN;
    PROCEDURE print_all_tracks
        (p_page IN NUMBER DEFAULT 1,
        p_elements_per_page IN NUMBER DEFAULT 15);
    PROCEDURE print_all_exercises
        (p_track IN NUMBER,
        p_page IN NUMBER DEFAULT 1,
        p_elements_per_page IN NUMBER DEFAULT 15);
END;
/

CREATE OR REPLACE PACKAGE BODY advanced_uc AS
    PROCEDURE promote_mentor
    (p_email IN US_USER.U_EMAIL%TYPE,
    p_success OUT INTEGER)
    AS
    BEGIN
        IF basic_uc.get_successful_submissions(p_email) >= 5
            THEN
                UPDATE US_USER SET U_IS_MENTOR = 1 WHERE U_EMAIL = p_email;
                basic_uc.log('User ''' || p_email || ''' is now a mentor!');
                p_success := 1;
            ELSE
                p_success := 0;
        END IF;
    END;

    PROCEDURE setup_test_runs
    (p_submitted IN INTEGER)
    AS
        v_count NUMBER;
        v_exercise NUMBER;
        e_not_found EXCEPTION;
        e_no_tests EXCEPTION;
    BEGIN
        SELECT SE_E_EXERCISE INTO v_exercise FROM SE_SUBMITTED_EXERCISE WHERE SE_ID = p_submitted;
        IF SQL%NOTFOUND
            THEN RAISE e_not_found;
        END IF;
        SELECT COUNT(*) INTO v_count FROM TE_TEST WHERE TE_E_EXERCISE = v_exercise;
        IF v_count = 0
            THEN RAISE e_no_tests;
        END IF;
        FOR x in (SELECT * FROM TE_TEST WHERE TE_E_EXERCISE = v_exercise) LOOP
            INSERT INTO TR_TEST_RUN (TR_TE_TEST, TR_SE_EXERCISE, TR_BEGIN, TR_END, TR_SUCCESS)
            VALUES (x.TE_ID, p_submitted, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);
        END LOOP;
    EXCEPTION
        WHEN e_not_found THEN RAISE_APPLICATION_ERROR(-20001, 'Submitted exercise not found!');
        WHEN e_no_tests THEN RAISE_APPLICATION_ERROR(-20002, 'No tests available to run!');
    END;

    FUNCTION check_if_user_absolved_concepts
    (p_user IN US_USER.U_ID%TYPE,
    p_exercise in NUMBER)
    RETURN BOOLEAN
    AS
        v_absolved BOOLEAN;
        v_count NUMBER;
        CURSOR c1 IS
        SELECT REQ_C_CONCEPT FROM REQ_REQUIRED_EXERCISES where REQ_E_EXERCISE = p_exercise;
    BEGIN
        v_absolved := TRUE;
        v_count := c1%ROWCOUNT;
        for x in c1 loop
            SELECT v_count - 1
            INTO v_count
            FROM AC_ABSOLVED_CONCEPTS
            WHERE AC_US_USER = p_user AND AC_C_CONCEPT = x.REQ_C_CONCEPT;
        end loop;
        IF v_count > 0 THEN
            v_absolved := FALSE;
        END IF;
        RETURN v_absolved;
    END;

    PROCEDURE print_all_tracks
        (p_page IN NUMBER DEFAULT 1,
        p_elements_per_page IN NUMBER DEFAULT 15)
    AS
        v_offset NUMBER := (p_page - 1) * p_elements_per_page;
        e_invalid_args EXCEPTION;
    BEGIN
        IF p_page < 1 OR p_elements_per_page < 1
            THEN RAISE e_invalid_args;
            ELSE
            DBMS_OUTPUT.PUT_LINE('Tracks in page ' || p_page);
            FOR track IN (SELECT T_ID, T_NAME, COUNT(MRT_ID) AS mentors, COUNT(TOFT_ID) AS tags
                          FROM TR_TRACK
                             INNER JOIN MRT_MENTOR_TRACKS MMT on TR_TRACK.T_ID = MMT.MRT_TR_TRACK
                             INNER JOIN TOFT_TAGS_OF_TRACKS TTOT on TR_TRACK.T_ID = TTOT.TOFT_TR_TRACK
                          GROUP BY T_ID, T_NAME
                          ORDER BY T_NAME
                          OFFSET v_offset ROWS
                                 FETCH NEXT p_elements_per_page ROWS ONLY)
            LOOP
                DBMS_OUTPUT.PUT_LINE(track.T_ID || ' -> ' || track.T_NAME ||
                ' | mentors: ' || track.mentors || ' | tags: ' || track.tags);
            end loop;
        END IF;
    EXCEPTION WHEN e_invalid_args THEN RAISE_APPLICATION_ERROR(-20004, 'Invalid page or amount.');
    end;

    PROCEDURE print_all_exercises
        (p_track IN NUMBER,
        p_page IN NUMBER DEFAULT 1,
        p_elements_per_page IN NUMBER DEFAULT 15)
    AS
        v_offset NUMBER := (p_page - 1) * p_elements_per_page;
        v_count NUMBER;
        e_not_found EXCEPTION;
        e_invalid_args EXCEPTION;
    BEGIN
        v_count := 0;
        SELECT T_ID into v_count FROM TR_TRACK WHERE T_ID = p_track;
        IF v_count = 0
            THEN RAISE e_not_found;
        END IF;
        IF p_page < 1 OR p_elements_per_page < 1
            THEN RAISE e_invalid_args;
            ELSE
            DBMS_OUTPUT.PUT_LINE('Exercises in page ' || p_page);
            FOR exercise IN (SELECT E_NAME, D_NAME
                             FROM E_EXERCISE
                             INNER JOIN D_DIFFICULTY DD on E_EXERCISE.E_D_DIFFICULTY = DD.D_ID
                             ORDER BY E_NAME
                             OFFSET v_offset ROWS
                                 FETCH NEXT p_elements_per_page ROWS ONLY)
            LOOP
                DBMS_OUTPUT.PUT_LINE(exercise.D_NAME || ' -> ' || exercise.E_NAME);
            end loop;
        END IF;
    EXCEPTION
        WHEN e_not_found THEN RAISE_APPLICATION_ERROR(-20003, 'Track not found!');
        WHEN e_invalid_args THEN RAISE_APPLICATION_ERROR(-20004, 'Invalid page or amount.');
    end;
END;
/

CREATE OR REPLACE TRIGGER tr_submission_watcher
    AFTER INSERT ON SE_SUBMITTED_EXERCISE
    FOR EACH ROW
BEGIN
    advanced_uc.setup_test_runs(:NEW.SE_E_EXERCISE);
END;
/
