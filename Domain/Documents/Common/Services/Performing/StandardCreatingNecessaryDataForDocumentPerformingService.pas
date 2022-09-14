unit StandardCreatingNecessaryDataForDocumentPerformingService;

interface

uses

  Document,
  Employee,
  IDocumentUnit,
  IncomingDocument,
  DocumentChargeInterface,
  DocumentChargeSheet,
  DocumentCharges,
  IDocumentChargeSheetUnit,
  DepartmentFinder,
  DocumentRegistrationService,
  DocumentChargeSheetControlService,
  DocumentChargeSheetAccessRights,
  CreatingNecessaryDataForDocumentPerformingService,
  SysUtils,
  Classes;

type

  TStandardCreatingNecessaryDataForDocumentPerformingService =
    class (
      TInterfacedObject,
      ICreatingNecessaryDataForDocumentPerformingService
    )

      protected

        FDocumentChargeSheetControlService: IDocumentChargeSheetControlService;

        function GetNecessaryDataForDocumentPerformingType:
          TNecessaryDataForDocumentPerformingClass; virtual;
          
      protected

        function CreateDocumentChargeSheetsFor(
          Document: IDocument;
          ChargeSheetSendingEmployee: TEmployee
        ): TDocumentChargeSheets;
        
        function CreateDocumentChargeSheetFor(
          Document: IDocument;
          DocumentCharge: IDocumentCharge;
          ChargeSheetSendingEmployee: TEmployee
        ): IDocumentChargeSheet;
        
      public

        constructor Create(
          DocumentChargeSheetControlService: IDocumentChargeSheetControlService
        );

        function CreateNecessaryDataForDocumentPerforming(
          Document: IDocument;
          InitiatingEmployee: TEmployee
        ): TNecessaryDataForDocumentPerforming; virtual;

    end;


implementation

uses

  DepartmentUnit,
  ServiceNote,
  IDomainObjectBaseUnit,
  IncomingServiceNote;
  
{ TStandardCreatingNecessaryDataForDocumentPerformingService }

constructor TStandardCreatingNecessaryDataForDocumentPerformingService.Create(
  DocumentChargeSheetControlService: IDocumentChargeSheetControlService
);
begin

  inherited Create;

  FDocumentChargeSheetControlService := DocumentChargeSheetControlService;
  
end;

function TStandardCreatingNecessaryDataForDocumentPerformingService.CreateNecessaryDataForDocumentPerforming(
  Document: IDocument;
  InitiatingEmployee: TEmployee
): TNecessaryDataForDocumentPerforming;
var
    DocumentCharge: TDocumentCharge;
    IncomingDocument: TIncomingDocument;
    DocumentChargeSheet: IDocumentChargeSheet;

    IncomingDocuments: TIncomingDocuments;
    DocumentChargeSheets: TDocumentChargeSheets;

    FreeIncomingDocument: IDomainObjectBase;
    FreeDocumentChargeSheet: IDomainObjectBase;
begin

  DocumentChargeSheets :=
    CreateDocumentChargeSheetsFor(Document, InitiatingEmployee);
      
  try

    Result :=
      GetNecessaryDataForDocumentPerformingType.CreateFrom(DocumentChargeSheets);
      
  except

    on e: Exception do begin

      FreeAndNil(DocumentChargeSheets);

      Raise;
      
    end;

  end;

end;

function TStandardCreatingNecessaryDataForDocumentPerformingService.CreateDocumentChargeSheetsFor(
  Document: IDocument;
  ChargeSheetSendingEmployee: TEmployee
): TDocumentChargeSheets;
var
    DocumentCharge: IDocumentCharge;
    DocumentChargeSheet: IDocumentChargeSheet;
begin

  Result := TDocumentChargeSheets.Create;

  try

    for DocumentCharge in Document.Charges do begin

      DocumentChargeSheet :=
        CreateDocumentChargeSheetFor(
          Document,
          DocumentCharge,
          ChargeSheetSendingEmployee
        );

      Result.AddDocumentChargeSheet(DocumentChargeSheet);

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TStandardCreatingNecessaryDataForDocumentPerformingService.
  CreateDocumentChargeSheetFor(
    Document: IDocument;
    DocumentCharge: IDocumentCharge;
    ChargeSheetSendingEmployee: TEmployee
  ): IDocumentChargeSheet;
var
    AccessRights: TDocumentChargeSheetAccessRights;
    Free: IDomainObjectBase;
begin

  FDocumentChargeSheetControlService.CreateHeadChargeSheet(
    Document,
    DocumentCharge.Performer,
    ChargeSheetSendingEmployee,
    Result,
    AccessRights
  );

  Free := AccessRights;

end;

function TStandardCreatingNecessaryDataForDocumentPerformingService.
  GetNecessaryDataForDocumentPerformingType: TNecessaryDataForDocumentPerformingClass;
begin

  Result := TNecessaryDataForDocumentPerforming;
  
end;

end.
