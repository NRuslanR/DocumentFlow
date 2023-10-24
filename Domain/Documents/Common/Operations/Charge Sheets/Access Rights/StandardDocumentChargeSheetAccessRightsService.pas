unit StandardDocumentChargeSheetAccessRightsService;

interface

uses

  DocumentChargeSheetAccessRightsService,
  DocumentChargeSheetAccessRights,
  DomainException,
  DocumentChargeSheet,
  Document,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetIssuingAccessRightsService,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetAccessRightsService =
    class (TInterfacedObject, IDocumentChargeSheetAccessRightsService)

      public

        function EnsureEmployeeHasDocumentChargeSheetAccessRights(
          Employee: TEmployee;
          ChargeSheet: IDocumentChargeSheet
        ): TDocumentChargeSheetAccessRights;

    end;

implementation

uses DocumentChargeSheetWorkingRules;

{ TStandardDocumentChargeSheetAccessRightsService }

function TStandardDocumentChargeSheetAccessRightsService.
  EnsureEmployeeHasDocumentChargeSheetAccessRights(
    Employee: TEmployee;
    ChargeSheet: IDocumentChargeSheet
  ): TDocumentChargeSheetAccessRights;
var
    ChargeSheetObj: TDocumentChargeSheet;
    AllowedChargeSheetFieldNames: TStrings;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  Result := TDocumentChargeSheetAccessRights.Create;

  try

    with Result, ChargeSheetObj.WorkingRules do begin

      ViewingAllowed :=
        DocumentChargeSheetViewingRule.IsSatisfiedBy(Employee, ChargeSheetObj);

      RemovingAllowed :=
        DocumentChargeSheetRemovingRule.IsSatisfiedBy(Employee, ChargeSheetObj);

      PerformingAllowed :=
        DocumentChargeSheetPerformingRule.IsSatisfiedBy(Employee, ChargeSheetObj);

      SubordinateChargeSheetsIssuingAllowed :=
        DocumentChargeSheetIssuingRule
          .CanEmployeeCanIssueSubordinateChargeSheet(
            Employee, ChargeSheetObj
          );
      
      AllowedChargeSheetFieldNames :=
        DocumentChargeSheetChangingRule
          .GetAlloweableDocumentChargeSheetFieldNames(
            Employee, ChargeSheetObj
          );

      if not Assigned(AllowedChargeSheetFieldNames) then Exit;

      try

        ChargeSectionAccessible :=
          AllowedChargeSheetFieldNames.IndexOf(ChargeSheetObj.ChargeTextPropName) <> -1;

        ResponseSectionAccessible :=
          AllowedChargeSheetFieldNames.IndexOf(ChargeSheetObj.PerformerResponsePropName) <> -1;
        
      finally

        FreeAndNil(AllowedChargeSheetFieldNames);

      end;

      if AllAccessRightsAbsent then begin

        Raise
          TDocumentChargeSheetAccessRightsServiceException.CreateFmt(
            'У сотрудника "%s" отсутствуют права доступа к ' +
            'поручению сотрудника "%s"',
            [
              Employee.FullName,
              ChargeSheetObj.Performer.FullName
            ]
          );

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
