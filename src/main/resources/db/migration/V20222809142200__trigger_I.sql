ALTER TABLE locations
    ADD department_amount NUMBER(6) NOT NULL;

--Compound trigger that keep track of departments count in every location
CREATE OR REPLACE TRIGGER departments_count_tr
    FOR INSERT OR DELETE OR UPDATE OF location_id ON departments
    --Compound trigger should provide the best balance between optimisation and database integrity
    COMPOUND TRIGGER
    TYPE locations_id_type IS TABLE OF locations.location_id % type INDEX BY BINARY_INTEGER;

    --Contains location IDs, where departments have been inserted, updated or deleted
    changed_locations locations_id_type;
    idx NUMBER;

    --row level trigger, is called before every operation on a row.
    --remembers location IDs, where departments were changed.
    --locations.department_amount is NOT changed yet.
    BEFORE EACH ROW IS
    BEGIN
        IF INSERTING OR UPDATING THEN changed_locations(: new.location_id) := : new.location_id;
        END IF;
        IF DELETING OR UPDATING THEN changed_locations(: old.location_id) := : old.location_id;
        END IF;
    END BEFORE EACH ROW;

    --table level trigger, is called only once, after all operations.
    --iterates through location IDs and update their department count.
    AFTER STATEMENT IS BEGIN idx := changed_locations.FIRST;
        WHILE idx IS NOT NULL LOOP
            UPDATE locations
            SET department_amount = (
                    SELECT COUNT(*)
                    FROM departments
                    WHERE location_id = idx
                    )
            WHERE location_id = idx;
            idx := changed_locations.NEXT(idx);
        END LOOP;
    END AFTER STATEMENT;
END departments_count_tr;
