unit StandardDocumentChargeSheetOverlappedPerformingRule;

interface

uses

  DocumentChargeSheetOverlappedPerformingRule,
  IDocumentChargeSheetUnit,
  EmployeeIsSameAsOrDeputySpecification,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetOverlappedPerformingRule =
    class (TInterfacedObject, IDocumentChargeSheetOverlappedPerformingRule)

      protected

        FEmployeeIsSameAsOrDeputySpecification:
          IEmployeeIsSameAsOrDeputySpecification;
          
      public

        constructor Create(

          EmployeeIsSameAsOrDeputySpecification:
            IEmployeeIsSameAsOrDeputySpecification

        );

        procedure EnsureThatChargeSheetPerformingMayBeOverlappedByOtherChargeSheet(
          TargetChargeSheet, OverlappingChargeSheet: IDocumentChargeSheet
        );

        function MayChargeSheetPerformingOverlappedByOtherChargeSheet(
          TargetChargeSheet, OverlappingChargeSheet: IDocumentChargeSheet
        ): Boolean;

    end;
    
implementation

uses

  DocumentChargeSheet,
  DocumentPerformingSheet;

{ TStandardDocumentChargeSheetOverlappedPerformingRule }

constructor TStandardDocumentChargeSheetOverlappedPerformingRule.Create(

  EmployeeIsSameAsOrDeputySpecification:
    IEmployeeIsSameAsOrDeputySpecification
            
);
begin

  inherited Create;

  FEmployeeIsSameAsOrDeputySpecification :=
    EmployeeIsSameAsOrDeputySpecification;
    
end;

function TStandardDocumentChargeSheetOverlappedPerformingRule.
  MayChargeSheetPerformingOverlappedByOtherChargeSheet(
    TargetChargeSheet, OverlappingChargeSheet: IDocumentChargeSheet
  ): Boolean;
begin

  try

    EnsureThatChargeSheetPerformingMayBeOverlappedByOtherChargeSheet(
      TargetChargeSheet, OverlappingChargeSheet
    );

    Result := True;

  except

    on e: TDocumentChargeSheetOverlappedPerformingRuleException do begin

      Result := False;

    end;

  end;

end;

procedure TStandardDocumentChargeSheetOverlappedPerformingRule.
  EnsureThatChargeSheetPerformingMayBeOverlappedByOtherChargeSheet(
    TargetChargeSheet, OverlappingChargeSheet: IDocumentChargeSheet
  );
var
    TargetChargeSheetObj,
    OverlappingChargeSheetObj: TDocumentChargeSheet;
begin

  TargetChargeSheetObj := TargetChargeSheet.Self as TDocumentChargeSheet;
  OverlappingChargeSheetObj := OverlappingChargeSheet.Self as TDocumentChargeSheet;

  if
    not (
      (TargetChargeSheetObj is TDocumentPerformingSheet) and
      (OverlappingChargeSheetObj is TDocumentPerformingSheet)
    )
  then begin
  
    Raise TNotValidChargeSheetTypeForOverlappedPerformingException.Create(
      '���������, �� ������� ��� "����������", �� ����� �������������'
    );

  end;

  if
    TargetChargeSheet.TopLevelChargeSheetId <> OverlappingChargeSheet.Identity
  then begin

    Raise TDocumentChargeSheetOverlappedPerformingRuleException.CreateFmt(
      '��������� ���������� "%s" �� �������� ����������� ��� ' +
      '��������� ���������� "%s"',
      [
        OverlappingChargeSheet.Performer.FullName,
        TargetChargeSheet.Performer.FullName
      ]
    );

  end;

  if not OverlappingChargeSheetObj.IsPerformed then begin

    Raise TDocumentChargeSheetOverlappedPerformingRuleException.CreateFmt(
      '���������, ����������� ' +
      '���������� "%s" �� ����� ���� ' +
      '���������, ��� ���������� ' +
      '����������, �������� ���������� ' +
      '"%s", ��������� ��������� ��� �� ' +
      '���������.',
      [
        TargetChargeSheetObj.Performer.FullName,
        OverlappingChargeSheetObj.Performer.FullName
      ]
    );

  end;

end;

end.
