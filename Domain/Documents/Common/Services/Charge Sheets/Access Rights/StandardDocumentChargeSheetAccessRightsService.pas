unit StandardDocumentChargeSheetAccessRightsService;

interface

uses

  DocumentChargeSheetAccessRightsService,
  DocumentChargeSheetAccessRights,
  DomainException,
  DocumentChargeSheet,
  IDocumentUnit,
  IDocumentChargeSheetUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetAccessRightsService =
    class (TInterfacedObject, IDocumentChargeSheetAccessRightsService)

      public

        function EnsureEmployeeHasDocumentChargeSheetAccessRights(
          Employee: TEmployee;
          ChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        ): TDocumentChargeSheetAccessRights;

    end;

implementation

uses DocumentChargeSheetWorkingRules;

{ TStandardDocumentChargeSheetAccessRightsService }

function TStandardDocumentChargeSheetAccessRightsService.
  EnsureEmployeeHasDocumentChargeSheetAccessRights(
    Employee: TEmployee;
    ChargeSheet: IDocumentChargeSheet;
    Document: IDocument
  ): TDocumentChargeSheetAccessRights;
var
    ChargeSheetObj: TDocumentChargeSheet;
    AllowedChargeSheetFieldNames: TStrings;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  ChargeSheetObj.EnsureBelongsToDocument(Document.Identity);

  Result := TDocumentChargeSheetAccessRights.Create;

  try

    with Result, ChargeSheetObj.WorkingRules do begin

      ViewingAllowed :=
        DocumentChargeSheetViewingRule.IsSatisfiedBy(Employee, ChargeSheetObj, Document);

      RemovingAllowed :=
        DocumentChargeSheetRemovingRule.IsSatisfiedBy(Employee, ChargeSheetObj, Document);

      PerformingAllowed :=
        DocumentChargeSheetPerformingRule.IsSatisfiedBy(Employee, ChargeSheetObj, Document);

      AllowedChargeSheetFieldNames :=
        DocumentChargeSheetChangingRule
          .GetAlloweableDocumentChargeSheetFieldNames(
            Employee, ChargeSheetObj, Document
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

        TDocumentChargeSheetAccessRightsServiceException.CreateFmt(
          'У сотрудника "%s" отсутствуют права доступа к ' +
          'поручению для сотрудника "%s"',
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
