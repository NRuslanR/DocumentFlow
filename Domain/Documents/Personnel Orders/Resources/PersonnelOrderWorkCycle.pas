unit PersonnelOrderWorkCycle;

interface

uses

  DocumentWorkCycle,
  SysUtils;

type

  TPersonnelOrderWorkCycle = class (TDocumentWorkCycle)

    protected

      function IsStageOfDocumentPerformedRequired: Boolean; override;
      function IsStageOfDocumentPerformingRequired: Boolean; override;

  end;

implementation

{ TPersonnelOrderWorkCycle }

function TPersonnelOrderWorkCycle.IsStageOfDocumentPerformedRequired: Boolean;
begin

  Result := False;

end;

function TPersonnelOrderWorkCycle.IsStageOfDocumentPerformingRequired: Boolean;
begin

  Result := False;
  
end;

end.
