*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class zcl_earth DEFINITION.

 PUBLIC SECTION.
 methods: start_engine RETURNING VALUE(e_result) TYPE STRING,
          lift_off RETURNING VALUE(e_result) TYPE STRING.

ENDCLASS.

class zcl_earth IMPLEMENTATION.

  METHOD lift_off.
    e_result = |We took off from earth|.
  ENDMETHOD.

  METHOD start_engine.
   e_result = |We started the engine again|.
  ENDMETHOD.

ENDCLASS.

class zcl_ip DEFINITION.


 PUBLIC SECTION.
 methods: enter_orbit RETURNING VALUE(e_result) TYPE STRING,
          leave_orbit RETURNING VALUE(e_result) TYPE STRING.

ENDCLASS.

class zcl_ip IMPLEMENTATION.

  METHOD enter_orbit.
e_result = |We enter the orbit of Planet 1|.
  ENDMETHOD.

  METHOD leave_orbit.
e_result = |We are leaving the orbit of planet 1|.
  ENDMETHOD.

ENDCLASS.


class zcl_mars DEFINITION.

PUBLIC SECTION.
 methods: enter_orbit RETURNING VALUE(e_result) TYPE STRING,
          explore RETURNING VALUE(e_result) TYPE STRING.

ENDCLASS.

class zcl_mars IMPLEMENTATION.

  METHOD enter_orbit.
e_result = |We enter the orbit of Mars|.
  ENDMETHOD.

  METHOD explore.
e_result = |Elon Buddy we found the water|.
  ENDMETHOD.

ENDCLASS.


