unit StandardGeneralIncomingDocumentChargeSheetAccessRightsService;

interface

uses

  StandardGeneralDocumentChargeSheetAccessRightsService,
  GeneralDocumentChargeSheetAccessRightsService,
  Document,
  Employee,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  IncomingDocument,
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  SysUtils;

type

  TStandardGeneralIncomingDocumentChargeSheetAccessRightsService =
    class (TStandardGeneralDocumentChargeSheetAccessRightsService)

      protected

        procedure SetDocumentChargeSheetsUsageAccessRights(
          AccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
          Document: TDocument;
          DocumentChargeSheets: IDocumentChargeSheets;
          Employee: TEmployee
        ); override;

        function FindAllChargeSheetsForDocument(Document: TDocument): TDocumentChargeSheets; override;

    end;

implementation

{ TStandardGeneralIncomingDocumentChargeSheetAccessRightsService }

function TStandardGeneralIncomingDocumentChargeSheetAccessRightsService.FindAllChargeSheetsForDocument(
  Document: TDocument
): TDocumentChargeSheets;
var
    IncomingDocument: TIncomingDocument;
begin

  IncomingDocument := Document as TIncomingDocument;

  Result :=
    FDocumentChargeSheetFinder.
      FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
        IncomingDocument.OriginalDocument.Identity,
        IncomingDocument.ReceiverId
      );
  
end;

procedure TStandardGeneralIncomingDocumentChargeSheetAccessRightsService.
  SetDocumentChargeSheetsUsageAccessRights(
    AccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
    Document: TDocument;
    DocumentChargeSheets: IDocumentChargeSheets;
    Employee: TEmployee
  );
begin

  inherited SetDocumentChargeSheetsUsageAccessRights(
    AccessRights,
    (Document as TIncomingDocument).OriginalDocument,
    DocumentChargeSheets,
    Employee
  );

end;

end.
