*&---------------------------------------------------------------------*
*& Report ZDEMO_EMP_DATA_RETRIEVAL
*&---------------------------------------------------------------------*
*& Examples of Inner Join, For All Entries, and Parallel Cursor
*& Adapted using your custom practice tables!
*& (ZKR_DT_EMP and ZKR_DT_EMP1)
*&---------------------------------------------------------------------*
REPORT zdemo_emp_data_retrieval.

START-OF-SELECTION.

  PERFORM get_data_inner_join.
  PERFORM get_data_for_all_entries.
  PERFORM get_data_parallel_cursor.

*&---------------------------------------------------------------------*
*&      Form  get_data_inner_join
*&---------------------------------------------------------------------*
FORM get_data_inner_join.
  WRITE: / '--- 1. INNER JOIN METHOD ---'.

  " We fetch the combined data in ONE single database trip
  SELECT FROM zkr_dt_emp AS a
    INNER JOIN zkr_dt_emp1 AS b
    ON a~emp_id = b~emp_id
    FIELDS a~emp_id,
           a~emp_name,
           a~emp_addr
    INTO TABLE @DATA(lt_joined_data).

  IF sy-subrc = 0.
    WRITE: / 'Inner Join successful! Combined rows found:', lines( lt_joined_data ).
    cl_demo_output=>display( data = lt_joined_data name = '1. Results from INNER JOIN' ).
  ELSE.
    WRITE: / 'No data found for Inner Join.'.
  ENDIF.
  SKIP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  get_data_for_all_entries
*&---------------------------------------------------------------------*
FORM get_data_for_all_entries.
  WRITE: / '--- 2. FOR ALL ENTRIES METHOD ---'.

  " Step 1: Get Employee Master Data
  SELECT FROM zkr_dt_emp
    FIELDS emp_id, emp_name
    INTO TABLE @DATA(lt_emp).

  " CRITICAL RULE: Always check if the first table has data!
  IF lt_emp IS NOT INITIAL.
    
    " Step 2: Get Employee Details based on the Master table
    SELECT FROM zkr_dt_emp1
      FOR ALL ENTRIES IN @lt_emp
      WHERE emp_id = @lt_emp-emp_id
      FIELDS *
      INTO TABLE @DATA(lt_emp1).

    IF sy-subrc = 0.
      WRITE: / 'For All Entries successful! Detail rows found:', lines( lt_emp1 ).
      cl_demo_output=>display( data = lt_emp1 name = '2. Results from FOR ALL ENTRIES' ).
    ENDIF.
  ELSE.
    WRITE: / 'No Master Data found for FAE.'.
  ENDIF.
  SKIP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  get_data_parallel_cursor
*&---------------------------------------------------------------------*
FORM get_data_parallel_cursor.
  WRITE: / '--- 3. PARALLEL CURSOR METHOD ---'.

  " Initial Data Fetch (Using FAE)
  SELECT FROM zkr_dt_emp
    FIELDS emp_id, emp_name, emp_addr
    INTO TABLE @DATA(lt_emp).

  IF lt_emp IS NOT INITIAL.
    SELECT FROM zkr_dt_emp1
      FOR ALL ENTRIES IN @lt_emp
      WHERE emp_id = @lt_emp-emp_id
      FIELDS *
      INTO TABLE @DATA(lt_emp1).
  ELSE.
    WRITE: / 'No Data found to process Parallel Cursor.'.
    RETURN.
  ENDIF.

  " The Parallel Cursor Optimization Strategy
  " Step 1: Both tables MUST be sorted by the matching key first
  SORT lt_emp BY emp_id.
  SORT lt_emp1 BY emp_id.

  DATA: lv_index TYPE sy-tabix,
        lv_count TYPE i.

  " Step 2: Loop your first table (Master)
  LOOP AT lt_emp INTO DATA(ls_emp).
    
    " Step 3: Find the starting row in the second table (Detail)
    READ TABLE lt_emp1 WITH KEY emp_id = ls_emp-emp_id BINARY SEARCH TRANSPORTING NO FIELDS.
    
    IF sy-subrc = 0.
      lv_index = sy-tabix. " Bookmark row!
      
      " Step 4: Loop Detail table starting ONLY from the bookmarked row number
      LOOP AT lt_emp1 INTO DATA(ls_emp1) FROM lv_index.
        
        IF ls_emp-emp_id <> ls_emp1-emp_id.
          EXIT. " Stop loop if Employee ID changes
        ENDIF.

        " ... Processing / combining your data happens here internally ...
        lv_count = lv_count + 1.
        
      ENDLOOP.
    ENDIF.
  ENDLOOP.
  
  WRITE: / 'Parallel Cursor looped', lv_count, 'times over matching records.'.
  SKIP.

ENDFORM.
