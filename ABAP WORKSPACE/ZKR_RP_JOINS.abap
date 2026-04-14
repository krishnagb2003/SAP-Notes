*&---------------------------------------------------------------------*
*& Report ZKR_RP_JOINS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkr_rp_joins.

  SELECT FROM zkr_dt_deptable1 AS a
   JOIN zkr_dt_emptable1 AS b
  ON a~dept_id = b~dept_id
  INNER JOIN ZKR_DT_salary1 AS c
  ON b~emp_id = c~emp_id
  FIELDS a~dept_id,
         b~emp_id,
         emp_name,
         dept_name,
         salary,
         grade
  WHERE dept_name = 'CS'
  INTO TABLE @DATA(lt_data1).
    SORT lt_data1 by grade.
  cl_demo_output=>display( lt_data1 ).

**************INNER JOIN for 2 tables****************
SELECT FROM zkr_dt_emp AS a
  INNER JOIN zkr_dt_emp1 AS b
 ON a~emp_id = b~emp_id
 FIELDS a~emp_id,
        a~emp_name,
          emp_addr
  INTO TABLE @DATA(lt_data2).

LOOP AT lt_data2 INTO DATA(ls_data2).
WRITE : / ls_data2.
ENDLOOP.
cl_demo_output=>display( lt_data2 ).

**************INNER JOIN for 3 tables****************
SELECT FROM zkr_dt_emp AS a
INNER JOIN zkr_dt_emp1 AS b
ON a~emp_id = b~emp_id
INNER JOIN zkr_dt_order AS c
ON b~emp_id = c~order_id
  FIELDS a~emp_id,
         a~EMP_name,
           EMP_SAL,
         EMP_addr,
         payment_mode

  INTO TABLE @DATA(lt_data3).
cl_demo_output=>display( lt_data3 ).



**************INNER JOIN for 4 tables****************
SELECT FROM zkr_dt_emp AS a
INNER JOIN zkr_dt_emp1 AS b
ON a~emp_id = b~emp_id
INNER JOIN zkr_dt_order AS c
ON b~emp_id = c~order_id
INNER JOIN zkr_dt_products AS d
ON c~order_id = d~P_ID
  FIELDS a~emp_id,
         a~EMP_name,
           EMP_SAL,
         EMP_addr,
         p_name,
         payment_mode
  INTO TABLE @DATA(lt_data4).
cl_demo_output=>display( lt_data4 ).


**************LEFT OUTER JOIN****************
SELECT FROM zkr_dt_emp AS a
  LEFT OUTER JOIN zkr_dt_products AS b
  ON a~EMP_ID = b~p_ID
  FIELDS a~EMP_ID,
         a~EMP_NAME,
           p_name
  INTO TABLE @DATA(lt_data5).

  cl_demo_output=>display( lt_data5 ).

***************RIGHT OUTER JOIN****************
SELECT FROM zkr_dt_emp AS a
    RIGHT OUTER JOIN zkr_dt_emp1 AS b
  ON a~emp_id = b~emp_id
  RIGHT OUTER JOIN zkr_dt_products AS c
  ON b~emp_id = c~p_id

  FIELDS a~emp_id,
         a~emp_name,
          emp_addr,
           p_name
  INTO TABLE @DATA(lt_data6).
cl_demo_output=>display( lt_data6 ).

************CROSS JOIN*****************************
SELECT FROM zkr_dt_emp as a
  CROSS JOIN zkr_dt_emp1
  Fields a~EMP_ID,
*         a~EMP_NAME,
          emp_addr
  INTO TABLE @DATA(lt_data7).

  cl_demo_output=>display( lt_data7 ).

*******************MARA MARC tables***********************************
SELECT FROM mara AS a
  INNER JOIN marc as b
  on a~MATNR = b~MATNR
  FIELDS a~VPSTA,
  a~MBRSH,
         b~PSTAT
  INTO TABLE @DATA(lt_data8) .
  cl_demo_output=>display( lt_data8 ).

  SELECT FROM mara AS a
 RIGHT
     OUTER JOIN marc as b
  on a~MATNR = b~MATNR
  FIELDS a~VPSTA,
         a~MBRSH,
         b~PSTAT
  INTO TABLE @DATA(lt_data9) .
  cl_demo_output=>display( lt_data9 ).

***************FOR ALL ENTRIES*******************
  DATA: lt_emp1 TYPE TABLE OF zkr_dt_emp1.

*" First fetch data into internal table
SELECT * FROM zkr_dt_emp1 INTO TABLE @lt_emp1.
cl_demo_output=>display( lt_emp1 ).
*" Then use FOR ALL ENTRIES
IF lt_emp1 IS NOT INITIAL.
  SELECT * FROM zkr_dt_emp
    INTO TABLE @DATA(lt_data10)
    FOR ALL ENTRIES IN @lt_emp1
    WHERE emp_id = @lt_emp1-emp_id.
ENDIF.
*
cl_demo_output=>display( lt_data10 ).

SELECT FROM zkr_dt_deptable1 AS a
  INNER JOIN zkr_dt_emptable1 AS b
  ON a~dept_id = b~dept_id
  INNER JOIN ZKR_DT_salary1 AS c
  ON b~emp_id = c~emp_id
  FIELDS a~dept_id,
         b~emp_id,
         emp_name,
         dept_name,
         salary,
         grade
*  WHERE dept_name = 'CS'
  INTO TABLE @DATA(lt_data11).
  cl_demo_output=>display( lt_data11 ).