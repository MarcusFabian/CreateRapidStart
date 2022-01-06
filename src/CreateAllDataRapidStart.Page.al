page 70000 "Create AllData Rapid Start"
{
    ApplicationArea = All;
    Caption = 'Create AllData Rapid Start';
    PageType = Card;
    SourceTable = "Config. Package Table";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            field(OnlyTableswithData; OnlyTableswithData)
            {
                ApplicationArea = All;
                Caption = 'Only Tables with Data';
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action(Go)
            {
                ApplicationArea = All;
                Caption = 'Create Rapidstart "_ALLDATA"', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = GoTo;
                trigger OnAction()
                var
                    CreateRapidstart: Codeunit "Create Rapidstart All";
                begin
                    CreateRapidstart.DoCreateRapidStartAll('_ALLDATA', OnlyTableswithData);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        OnlyTableswithData := false;
    end;

    var
        OnlyTableswithData: Boolean;
}
