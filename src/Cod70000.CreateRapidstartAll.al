codeunit 70000 "Create Rapidstart All"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        // DoCreateRapidStartAll('_ALLDATA');
    end;

    local procedure TableToExclude(ID: Integer): Boolean;
    var
        TableMetadata: Record "Table Metadata";
    begin
        if TableMetadata.Get(ID) then
            if TableMetadata.TableType <> TableMetadata.TableType::Normal then
                Exit(true);
        if ID = 265 THEN EXIT(TRUE); // Document Entry
        if ID = 338 THEN EXIT(TRUE); // Entry summary
        if ID = 405 THEN EXIT(TRUE); // Change log Entry
        if ID = 486 THEN EXIT(TRUE); // Business Chart Map
        if ID = 487 THEN EXIT(TRUE); // Business Chart User Setup
        if ID = 491 THEN EXIT(TRUE); // Parallel Session Entry
        if ID = 520 THEN EXIT(TRUE); // Available Info. Buffer
        if ID = 1173 THEN EXIT(TRUE); // Document Attachment
        if ID = 1803 THEN EXIT(TRUE); // Assisted Setup
        IF ID = 8613 THEN EXIT(TRUE);  // Config. Package Table
        IF ID = 8614 THEN EXIT(TRUE);  // Config. Package Record
        IF ID = 8615 THEN EXIT(TRUE);  // Config. Package Data
        IF ID = 8616 THEN EXIT(TRUE);  // Config. Package Field
        IF ID = 8617 THEN EXIT(TRUE);  // Config. Package Error
        IF ID = 2190 THEN EXIT(TRUE);  // O365 Sales Graph
        IF ID = 5450 THEN EXIT(TRUE);  // Graph Contact
        IF ID = 5455 THEN EXIT(TRUE);  // Graph Subscription
        IF ID = 5456 THEN EXIT(TRUE);  // Graph Business Profile
        IF ID = 5460 THEN EXIT(TRUE);  // Graph Business Setting
        IF ID = 5723 THEN EXIT(TRUE);  // Product Group
        IF ID = 6701 THEN EXIT(TRUE);  // Change Contact
        IF ID = 6703 THEN EXIT(TRUE);  // Booking Service
        IF ID = 6704 THEN EXIT(TRUE);  // Booking Mailbox
        IF ID = 6705 THEN EXIT(TRUE);  // Booking Staff
        IF ID = 6706 THEN EXIT(TRUE);  // Booking Service Mapping
        IF ID = 6707 THEN EXIT(TRUE);  // Booking Item
        IF ID = 7860 THEN EXIT(TRUE);  // MS- PayPal Standard Account
        IF ID = 7861 THEN EXIT(TRUE);  // MS- PayPal Standard Template
        IF ID = 7862 THEN EXIT(TRUE);  // MS- PayPal Transaction
        EXIT(FALSE);
    end;

    procedure DoCreateRapidStartAll(PackageName: Code[20]; WithDataOnly: Boolean)
    var
        ConfigPackage: Record "Config. Package";
        ConfigLine: Record "Config. Package Table";
        ConfigPackageField: Record "Config. Package Field";
        Object: Record AllObjWithCaption;
        rRef: RecordRef;
        fRef: FieldRef;
        i: Integer;
        TableIDFilter: Text;
        gTableCounter: Integer;
        gFieldCounter: Integer;
        dlg: Dialog;
    begin
        // Delete and recreate Package
        IF ConfigPackage.GET(PackageName) THEN
            ConfigPackage.DELETE(TRUE);
        ConfigPackage.RESET();
        ConfigPackage.INIT;
        ConfigPackage.Code := PackageName;
        If WithDataOnly then
            ConfigPackage."Package Name" := 'All Tables with entries'
        else
            ConfigPackage."Package Name" := 'All Tables, empty or not';
        ConfigPackage."Language ID" := 2055;
        ConfigPackage."Product Version" := FORMAT(WORKDATE);
        ConfigPackage."Exclude Config. Tables" := FALSE;
        ConfigPackage.INSERT(TRUE);
        dlg.OPEN('Table #1##############');
        ConfigLine.RESET;
        ConfigLine.SETRANGE("Package Code", PackageName);
        ConfigLine."Package Code" := PackageName;
        TableIDFilter := '..5339|5400..2000000000';
        Object.SETRANGE("Object Type", Object."Object Type"::Table);
        Object.SETFILTER("Object ID", TableIDFilter);
        IF Object.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF NOT TableToExclude(Object."Object ID") THEN BEGIN
                    dlg.UPDATE(1, Object."Object ID");
                    rRef.OPEN(Object."Object ID");
                    if rRef.ReadPermission() then begin
                        // Only Process Tables with Data?
                        if (rRef.COUNT > 0) or (Not WithDataOnly) THEN BEGIN
                            gTableCounter += 1;
                            ConfigLine.INIT;
                            ConfigLine."Table ID" := Object."Object ID";
                            ConfigLine."Skip Table Triggers" := TRUE;
                            ConfigLine.INSERT(TRUE);

                            // Fields
                            ConfigPackageField.INIT;
                            ConfigPackageField."Package Code" := ConfigLine."Package Code";
                            ConfigPackageField."Table ID" := ConfigLine."Table ID";
                            i := 1;
                            REPEAT
                                CLEAR(fRef);
                                fRef := rRef.FIELDINDEX(i);
                                IF fRef.ACTIVE THEN BEGIN
                                    gFieldCounter += 1;
                                    ConfigPackageField."Field ID" := fRef.NUMBER;
                                    IF ConfigPackageField.INSERT(FALSE) THEN;
                                    ConfigPackageField."Include Field" := TRUE;
                                    ConfigPackageField."Validate Field" := FALSE;
                                    ConfigPackageField."Processing Order" := i;
                                    ConfigPackageField.MODIFY;
                                END;
                                i += 1;
                            UNTIL (i > rRef.FIELDCOUNT);
                            COMMIT;
                        END;  // Count > 0
                    end;
                    rRef.CLOSE;
                END;  // not exclude
            UNTIL Object.NEXT = 0;
        dlg.CLOSE;
        MESSAGE('Done! Added %1 tables, %2 fields', gTableCounter, gFieldCounter);

    end;
}
