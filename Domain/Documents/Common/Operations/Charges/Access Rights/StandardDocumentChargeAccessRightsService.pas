unit StandardDocumentChargeAccessRightsService;

interface

uses

  DocumentChargeAccessRightsService,
  DocumentChargeAccessRights,
  Employee,
  DocumentChargeInterface,
  IDocumentUnit,
  DomainException,
  DocumentCharges,
  Document,
  SysUtils;

type

  TStandardDocumentChargeAccessRightsService =
    class (TInterfacedObject, IDocumentChargeAccessRightsService)

      public

        function EnsureEmployeeHasDocumentChargeAccessRights(
          Employee: TEmployee;
          DocumentCharge: IDocumentCharge;
          Document: IDocument
        ): TDocumentChargeAccessRights;

    end;

implementation

{ TStandardDocumentChargeAccessRightsService }

function TStandardDocumentChargeAccessRightsService.
  EnsureEmployeeHasDocumentChargeAccessRights(
    Employee: TEmployee;
    DocumentCharge: IDocumentCharge;
    Document: IDocument
  ): TDocumentChargeAccessRights;
var
    DocumentObj: TDocument;
    DocumentChargeObj: TDocumentCharge;
begin

  DocumentObj := TDocument(Document.Self);
  DocumentChargeObj := TDocumentCharge(DocumentCharge.Self);

  Result := TDocumentChargeAccessRights.Create;

  try

    Result.ChargeSectionAccessible :=
      DocumentChargeObj.WorkingRules.ChangingRule.MayEmployeeChangeDocumentCharge(
        Employee,
        Document,
        DocumentCharge,
        [
          DocumentChargeObj.ChargeTextPropName
        ]
      );

    Result.RemovingAllowed :=
      DocumentObj.WorkingRules.ChargeListChangingRule.MayEmployeeRemoveDocumentCharge(
        Employee, Document, DocumentCharge
      );

    if Result.AllAccessRightsAbsent then begin

      raise TDocumentChargeAccessRightsServiceException.CreateFmt(
        'Отсутствуют права доступа к поручению сотрудника "%s"',
        [
          DocumentCharge.Performer.FullName
        ]
      );
      
    end;
      
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
