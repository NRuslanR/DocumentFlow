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
  DocumentAcquaitanceSheet;

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
    (TargetChargeSheetObj is TDocumentAcquaitanceSheet) or
    (OverlappingChargeSheetObj is TDocumentAcquaitanceSheet)
  then begin
  
    Raise TNotValidChargeSheetTypeForOverlappedPerformingException.Create(
      '���������� ��������� ���� "������������" �� ����� �������������'
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

  {
  if
    not
    FEmployeeIsSameAsOrDeputySpecification
      .IsEmployeeSameAsOrDeputyForOtherOrViceVersa(
        OverlappingChargeSheetObj.Performer,
        TargetChargeSheetObj.Issuer
       )
  then begin

    Raise TDocumentChargeSheetOverlappedPerformingRuleException.CreateFmt(
      '��������� "%s" ��� ��� ' +
      '����������� ����������� ' +
      '�� �������� ������������ ' +
      '��������� ��� ���������� "%s", ' +
      '������� ���������� �������  ' +
      '��������� �� ����� ���� ���������',
      [
        OverlappingChargeSheetObj.Performer.FullName,
        TargetChargeSheetObj.Performer.FullName
      ]
    );

  end;      }

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

end.
