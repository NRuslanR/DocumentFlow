unit ToDocumentApprovingSheetApprovingsPicker;

interface

uses

  AbstractDocumentApprovingsPicker,
  DocumentApprovings,
  DocumentApprovingCycleResult,
  Employee,
  SysUtils;

type

  TToDocumentApprovingSheetApprovingsPicker = class (TAbstractDocumentApprovingsPicker)

    protected

      function InternalPickDocumentApprovingsFrom(
        const DocumentApprovings: TDocumentApprovings = nil;
        const DocumentApprovingCycleResults: TDocumentApprovingCycleResults = nil
      ): TDocumentApprovings; override;
    
  end;

  
implementation

{ TToDocumentApprovingSheetApprovingsPicker }

function TToDocumentApprovingSheetApprovingsPicker.
  InternalPickDocumentApprovingsFrom(
    const DocumentApprovings: TDocumentApprovings;
    const DocumentApprovingCycleResults: TDocumentApprovingCycleResults
  ): TDocumentApprovings;
var
    DocumentApproving: TDocumentApproving;
    PreviousDocumentApprovings: TDocumentApprovings;
    ApprovingIndex: Integer;
    Approver: TEmployee;
    SatisfyingDocumentApproving: TDocumentApproving;
    J, I: Integer;
    SucceedingDocumentApprovings: TDocumentApprovings;
begin

  Result := TDocumentApprovings.Create;

  try

    if Assigned(DocumentApprovings) then begin

      for DocumentApproving in DocumentApprovings do
        Result.Add(DocumentApproving);

    end;

    if not Assigned(DocumentApprovingCycleResults) then Exit;
    
    DocumentApprovingCycleResults.OrderByCycleNumber;

    for I := 0 to DocumentApprovingCycleResults.Count - 1 do begin

      PreviousDocumentApprovings :=
        DocumentApprovingCycleResults[I].DocumentApprovings;

      for ApprovingIndex := 0 to PreviousDocumentApprovings.Count - 1
      do begin

        Approver := PreviousDocumentApprovings[ApprovingIndex].Approver;

        if Result.IsEmployeeAssignedAsApprover(Approver) then Continue;
        
        SatisfyingDocumentApproving :=
          PreviousDocumentApprovings[ApprovingIndex];
      
        for J := I + 1 to DocumentApprovingCycleResults.Count - 1 do begin

          SucceedingDocumentApprovings :=
            DocumentApprovingCycleResults[J].DocumentApprovings;

          DocumentApproving :=
            SucceedingDocumentApprovings.FindByApprover(Approver);

          if Assigned(DocumentApproving) then
            SatisfyingDocumentApproving := DocumentApproving;

        end;

        Result.Add(SatisfyingDocumentApproving);

      end;

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

end.
