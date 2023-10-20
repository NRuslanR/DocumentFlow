unit StandardDocumentChargeSheetPerformingRule;

interface

uses

  StandardDocumentChargeSheetWorkingRule,
  Employee,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  DocumentChargeSheetWorkingRule,
  DocumentChargeSheetPerformingRule,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetPerformingRule =
    class (
      TStandardDocumentChargeSheetWorkingRule,
      IDocumentChargeSheetPerformingRule
    )

      protected

        procedure RaiseExceptionIfChargeSheetIsNotValid(
          DocumentChargeSheet: TDocumentChargeSheet;
          Employee: TEmployee
        );

        function IsChargeSheetValid(
          ChargeSheet: TDocumentChargeSheet;
          Employee: TEmployee;
          var ErrorMessage: String
        ): Boolean; virtual;

        procedure RaiseExceptionIfDocumentChargeSheetTimeFrameIsExpired(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetPerforming(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        );

      protected

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        ); override;

    end;

implementation

uses

  DocumentAcquaitanceSheet;
  
{ TStandardDocumentChargeSheetPerformingRule }

procedure TStandardDocumentChargeSheetPerformingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  RaiseExceptionIfChargeSheetIsNotValid(
    DocumentChargeSheet, Employee
  );
                                        
  RaiseExceptionIfDocumentChargeSheetTimeFrameIsExpired(
    Employee, DocumentChargeSheet
  );

  RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetPerforming(
    Employee, DocumentChargeSheet
  );

end;

procedure TStandardDocumentChargeSheetPerformingRule.
  RaiseExceptionIfChargeSheetIsNotValid(
    DocumentChargeSheet: TDocumentChargeSheet;
    Employee: TEmployee
  );
var
    ErrorMessage: String;
begin

  if not IsChargeSheetValid(DocumentChargeSheet, Employee, ErrorMessage)
  then begin

    raise TDocumentChargeSheetWorkingRuleException.Create(ErrorMessage);

  end;

end;

function TStandardDocumentChargeSheetPerformingRule.IsChargeSheetValid(
  ChargeSheet: TDocumentChargeSheet;
  Employee: TEmployee;
  var ErrorMessage: String
): Boolean;
begin

  Result := not ChargeSheet.IsPerformed;

  if not Result then begin

    ErrorMessage :=
      Format(
        '���������, �������� ���������� "%s", ��� ���������',
        [
          ChargeSheet.Performer.FullName
        ]
      );

  end;

end;

procedure TStandardDocumentChargeSheetPerformingRule.
  RaiseExceptionIfDocumentChargeSheetTimeFrameIsExpired(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  {
    �������� ���������� ������� ��
    ���������� ��������� �� ��������
    ����������� ��� ����������
    �� ������ ������
  }
  
end;

procedure TStandardDocumentChargeSheetPerformingRule.
  RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetPerforming(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  if not Assigned(DocumentChargeSheet.Performer) then begin

    Raise TDocumentChargeSheetWorkingRuleException.CreateFmt(
            '��������� "%s" �� ����� ��������� ' +
            '���������, ��������� ��� ���� ' +
            '�� ��� �������� �����������',
            [
              Employee.FullName
            ]
          );

  end;

  if
      not (
        FEmployeeIsSameAsOrDeputySpecification.
          IsEmployeeSameAsOrDeputyForOther(
            Employee, DocumentChargeSheet.Performer
          )
        or
        DocumentChargeSheet.Performer.IsSubLeaderFor(Employee)
      )

  then begin

    Raise TDocumentChargeSheetWorkingRuleException.CreateFmt(
            '��������� "%s" �� ����� ��������� ' +
            '���������, ��������� �� �������� ' +
            '����������� ����������� ��� ' +
            '������������ ����������� "%s"',
            [
              Employee.FullName,
              DocumentChargeSheet.Performer.FullName
            ]
          );

  end;

end;

end.
