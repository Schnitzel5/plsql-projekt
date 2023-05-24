CREATE OR REPLACE TYPE ARRAY_TEST is table of varchar2(2048);

CREATE OR REPLACE PACKAGE test_use_cases AS
    --%suite

    --%test()
    PROCEDURE check_create_user;

    --%test()
    PROCEDURE check_if_submitted_exercise_successful;

    --%test()
    PROCEDURE check_get_successful_submissions;

    --%test()
    PROCEDURE check_create_exercise;

    --%test()
    PROCEDURE check_create_test;

    --%test()
    PROCEDURE check_log;

    --%test()
    PROCEDURE check_promote_mentor;

    --%test()
    PROCEDURE check_setup_test_runs;

    --%test()
    PROCEDURE check_if_user_absolved_concepts;

    --%test()
    PROCEDURE check_print_all_tracks;

    --%test()
    PROCEDURE check_print_all_exercises;
END;
/

CREATE OR REPLACE PACKAGE BODY test_use_cases AS
    PROCEDURE check_create_user
        IS
    BEGIN
        ut.expect(basic_uc.create_user('test', 'test')).to_equal(TRUE);
        ut.expect(basic_uc.create_user('test', 'test')).to_equal(FALSE);
    END;

    PROCEDURE check_if_submitted_exercise_successful
    IS
    BEGIN
        utt.expect(basic_uc.CHECK_IF_SUBMITTED_EXERCISE_SUCCESSFUL(1)).to_equal(TRUE);
        INSERT INTO TR_TEST_RUN (TR_TE_TEST, TR_SE_EXERCISE, TR_BEGIN, TR_END, TR_SUCCESS) VALUES (1, 1, SYSDATE, SYSDATE, 0);
        ut.expect(basic_uc.CHECK_IF_SUBMITTED_EXERCISE_SUCCESSFUL(1)).to_equal(FALSE);
    END;

    PROCEDURE check_get_successful_submissions
    IS
    BEGIN
        BASIC_UC.SUBMIT_SOLUTION(1, 1, 1, 'test');
        ut.expect(basic_uc.GET_SUCCESSFUL_SUBMISSIONS(1)).to_equal(1);
    END;

    PROCEDURE check_create_exercise
    IS
        v_count NUMBER;
    BEGIN
        BASIC_UC.CREATE_EXERCISE('Jeff', 'This is jeff. Our Test prob.', 1, 1);
        SELECT COUNT(*) INTO v_count FROM E_EXERCISE WHERE E_NAME = 'Jeff';
        ut.expect(v_count).to_equal(1);
    END;

    PROCEDURE check_create_test
    IS
        v_id NUMBER;
        v_count NUMBER;
    BEGIN
        SELECT E_ID INTO v_id FROM E_EXERCISE WHERE E_NAME = 'Jeff';
        SELECT COUNT(*) INTO v_count FROM TE_TEST WHERE TE_E_EXERCISE = v_id;
        ut.expect(v_count).to_equal(1);
        BASIC_UC.CREATE_TEST(v_count, ARRAY_TEST('random code', 'code your own way', 'coding your way out of the code'));
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
    END;
END;
/
