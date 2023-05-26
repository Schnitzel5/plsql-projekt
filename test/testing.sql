CREATE OR REPLACE PACKAGE test_use_cases AS
    -- %suite

    -- %test
    PROCEDURE check_create_user;

    -- %test
    PROCEDURE check_submit_solution;

    -- %test
    PROCEDURE check_get_successful_submissions;

    -- %test
    PROCEDURE check_if_submitted_exercise_successful;

    -- %test
    PROCEDURE check_create_exercise;

    -- %test
    PROCEDURE check_create_test;

    -- %test
    -- %throws(-20001)
    PROCEDURE check_create_test_not_found;

    -- %test
    PROCEDURE check_log;

    -- %test
    PROCEDURE check_promote_mentor;

    -- %test
    PROCEDURE check_if_user_absolved_concepts;
END;
/

CREATE OR REPLACE PACKAGE BODY test_use_cases AS
    PROCEDURE check_create_user
        IS
    BEGIN
        ut.expect(basic_uc.create_user('test', 'test', 'IAmADuck2')).to_equal(TRUE);
        ut.expect(basic_uc.create_user('test', 'test', NULL)).to_equal(FALSE);
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;

    PROCEDURE check_submit_solution
    IS
    BEGIN
        ut.expect(basic_uc.GET_SUCCESSFUL_SUBMISSIONS(4)).to_equal(0);
        BASIC_UC.SUBMIT_SOLUTION(5, 4, 0, 'some code');
        ut.expect(basic_uc.GET_SUCCESSFUL_SUBMISSIONS(4)).to_equal(1);
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;

    PROCEDURE check_get_successful_submissions
    IS
    BEGIN
        BASIC_UC.SUBMIT_SOLUTION(5, 4, 0, 'some code');
        ut.expect(basic_uc.GET_SUCCESSFUL_SUBMISSIONS(4)).to_equal(1);
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;

    PROCEDURE check_if_submitted_exercise_successful
    IS
        v_id NUMBER;
    BEGIN
        BASIC_UC.SUBMIT_SOLUTION(5, 4, 0, 'some code');
        SELECT SE_ID INTO v_id FROM SE_SUBMITTED_EXERCISE WHERE SE_E_EXERCISE = 5 AND SE_US_USER = 4;
        ut.expect(basic_uc.CHECK_IF_SUBMITTED_EXERCISE_SUCCESSFUL(v_id)).to_equal(TRUE);
        INSERT INTO TR_TEST_RUN (TR_TE_TEST, TR_SE_EXERCISE, TR_BEGIN, TR_END, TR_SUCCESS) VALUES (1, v_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0);
        ut.expect(basic_uc.CHECK_IF_SUBMITTED_EXERCISE_SUCCESSFUL(v_id)).to_equal(FALSE);
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;

    PROCEDURE check_create_exercise
    IS
        v_count NUMBER;
    BEGIN
        BASIC_UC.CREATE_EXERCISE('Jeff', 'This is jeff. Our Test prob.', 1, 1);
        SELECT COUNT(*) INTO v_count FROM E_EXERCISE WHERE E_NAME = 'Jeff';
        ut.expect(v_count).to_equal(1);
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;

    PROCEDURE check_create_test
    IS
        v_id NUMBER;
        v_count NUMBER;
    BEGIN
        BASIC_UC.CREATE_EXERCISE('Jeff', 'This is jeff. Our Test prob.', 1, 1);
        SELECT E_ID INTO v_id FROM E_EXERCISE WHERE E_NAME = 'Jeff';
        SELECT COUNT(*) INTO v_count FROM TE_TEST WHERE TE_E_EXERCISE = v_id;
        ut.expect(v_count).to_equal(0);
        BASIC_UC.CREATE_TEST(v_id, ARRAY_TEST('random code', 'code your own way', 'coding your way out of the code'));
        SELECT COUNT(*) INTO v_count FROM TE_TEST WHERE TE_E_EXERCISE = v_id;
        ut.expect(v_count).to_equal(3);
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;

    PROCEDURE check_create_test_not_found
    IS
    BEGIN
        BASIC_UC.CREATE_TEST(999, ARRAY_TEST('random code', 'code your own way', 'coding your way out of the code'));
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;

    PROCEDURE check_log
    AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM AL_AUDIT_LOG;
        ut.expect(v_count).to_equal(0);
        BASIC_UC.LOG('Test log message.');
        SELECT COUNT(*) INTO v_count FROM AL_AUDIT_LOG;
        ut.expect(v_count).to_equal(1);
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;

    PROCEDURE check_promote_mentor
    AS
        v_success INTEGER;
    BEGIN
        ADVANCED_UC.PROMOTE_MENTOR('jroyston2@mapy.cz', v_success);
        ut.expect(v_success).to_equal(0);
        BASIC_UC.SUBMIT_SOLUTION(1, 3, 0, 'some code');
        BASIC_UC.SUBMIT_SOLUTION(2, 3, 0, 'some code');
        BASIC_UC.SUBMIT_SOLUTION(3, 3, 0, 'some code');
        BASIC_UC.SUBMIT_SOLUTION(4, 3, 0, 'some code');
        BASIC_UC.SUBMIT_SOLUTION(5, 3, 0, 'some code');
        ADVANCED_UC.PROMOTE_MENTOR('jroyston2@mapy.cz', v_success);
        ut.expect(v_success).to_equal(1);
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;

    PROCEDURE check_if_user_absolved_concepts
    AS
    BEGIN
        ut.expect(ADVANCED_UC.CHECK_IF_USER_ABSOLVED_CONCEPTS(4, 3)).to_equal(FALSE);
        INSERT INTO AC_ABSOLVED_CONCEPTS (AC_US_USER, AC_C_CONCEPT) VALUES (4, 1);
        ut.expect(ADVANCED_UC.CHECK_IF_USER_ABSOLVED_CONCEPTS(4, 3)).to_equal(TRUE);
        FOR log IN (SELECT * FROM AL_AUDIT_LOG) LOOP
            DBMS_OUTPUT.PUT_LINE(log.AL_DATE || ' | ' || log.AL_INFO);
        end loop;
    END;
END;
/
