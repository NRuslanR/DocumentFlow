unit StandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService;

interface

uses

  IDocumentUnit,
  DocumentCharges,
  Document,
  DocumentChargeInterface,
  IncomingDocument,
  Employee,
  DocumentRegistrationService,
  CreatingNecessaryDataForDocumentPerformingService,
  DocumentChargeSheetControlService,
  DocumentCreatingService,
  IncomingDocumentCreatingService,
  StandardCreatingNecessaryDataForDocumentPerformingService,
  CreatingNecessaryDataForCrossDepartmentDocumentPerformingService,
  SysUtils;

type

  TStandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService =
    class (
      TStandardCreatingNecessaryDataForDocumentPerformingService,
      ICreatingNecessaryDataForCrossDepartmentDocumentPerformingService
    )

      private

        FIncomingDocumentCreatingService: IIncomingDocumentCreatingService;
        FDocumentRegistrationService: IDocumentRegistrationService;

      protected

        function GetNecessaryDataForDocumentPerformingType:
          TNecessaryDataForDocumentPerformingClass; override;

      private

        function CreateIncomingDocmentsFor(
          Document: IDocument;
          InitiatingEmployee: TEmployee
        ): TIncomingDocuments;

        function CreateIncomingDocumentListInstanceBy(
          Document: IDocument
        ): TIncomingDocuments;

        function CreateIncomingDocumentInstanceFor(
          Document: IDocument;
          Receiver: TEmployee
        ) : TIncomingDocument;

        function CreateAndRegisterIncomingDocumentFor(
          Document: IDocument;
          DocumentCharge: IDocumentCharge
        ): TIncomingDocument;

      public

        constructor Create(
          DocumentChargeSheetControlService: IDocumentChargeSheetControlService;
          DocumentRegistrationService: IDocumentRegistrationService;
          IncomingDocumentCreatingService: IIncomingDocumentCreatingService
        );

        function CreateNecessaryDataForDocumentPerforming(
          Document: IDocument;
          InitiatingEmployee: TEmployee
        ): TNecessaryDataForDocumentPerforming; override;

    end;

implementation

uses

  IDomainObjectBaseUnit;
  
constructor TStandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService.Create(
  DocumentChargeSheetControlService: IDocumentChargeSheetControlService;
  DocumentRegistrationService: IDocumentRegistrationService;
  IncomingDocumentCreatingService: IIncomingDocumentCreatingService
);
begin

  inherited Create(DocumentChargeSheetControlService);

  FDocumentRegistrationService := DocumentRegistrationService;
  FIncomingDocumentCreatingService := IncomingDocumentCreatingService;

end;

function TStandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService.
  GetNecessaryDataForDocumentPerformingType: TNecessaryDataForDocumentPerformingClass;
begin

  Result := TNecessaryDataForCrossDepartmentDocumentPerforming;
  
end;

function TStandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService.
  CreateNecessaryDataForDocumentPerforming(
    Document: IDocument;
    InitiatingEmployee: TEmployee
  ): TNecessaryDataForDocumentPerforming;
begin

  Result :=
    inherited CreateNecessaryDataForDocumentPerforming(Document, InitiatingEmployee);

  try

    with TNecessaryDataForCrossDepartmentDocumentPerforming(Result) do begin

      IncomingDocuments :=
        CreateIncomingDocmentsFor(Document, InitiatingEmployee);

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TStandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService.
  CreateIncomingDocmentsFor(
    Document: IDocument;
    InitiatingEmployee: TEmployee
  ): TIncomingDocuments;
var
    DocumentCharge: IDocumentCharge;
    IncomingDocument: TIncomingDocument;
    FreeIncomingDocument: IDomainObjectBase;
begin

  Result := CreateIncomingDocumentListInstanceBy(Document);

  try

    for DocumentCharge in Document.Charges do begin
    
      IncomingDocument := 
        CreateAndRegisterIncomingDocumentFor(Document, DocumentCharge);

      FreeIncomingDocument := IncomingDocument;

      Result.AddDocument(IncomingDocument);

    end;
    
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TStandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService.
  CreateAndRegisterIncomingDocumentFor(
    Document: IDocument;
    DocumentCharge: IDocumentCharge
  ): TIncomingDocument;

begin

  Result := CreateIncomingDocumentInstanceFor(Document, DocumentCharge.Performer);

  try

    FDocumentRegistrationService.RegisterDocument(Result);
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TStandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService.
  CreateIncomingDocumentListInstanceBy(
    Document: IDocument
  ): TIncomingDocuments;
var 
    IncomingDocumentListType: TIncomingDocumentsClass;
    RealDocument: TDocument;
begin

  RealDocument := Document.Self as TDocument;

  IncomingDocumentListType := TIncomingDocumentClass(RealDocument.IncomingDocumentType).IncomingListType;
  
  if not Assigned(IncomingDocumentListType) then begin

    raise TCreatingNecessaryDataForDocumentPerformingServiceException.Create(
            'Невозможно сформировать ' +
            'необходимые данные для ' +
            'исполнения документа. Для типа ' +
            'этого документа не найден ' +
            'соответствующий тип входящих документов'
          );

  end;
  
  Result := IncomingDocumentListType.Create;

end;

function TStandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService.
  CreateIncomingDocumentInstanceFor(
    Document: IDocument;
    Receiver: TEmployee
  ): TIncomingDocument;
begin

  Result :=
    FIncomingDocumentCreatingService
      .CreateIncomingDocumentInstanceFor(
        TDocument(Document.Self), Receiver
      );

  if not Assigned(Result) then begin

    raise TCreatingNecessaryDataForDocumentPerformingServiceException.Create(
    	'Невозможно сформировать ' +
      'необходимые данные для ' +
      'исполнения документа. Для типа ' +
      'этого документа не удалось создать ' +
      'соответствующий входящий документ'
    );

  end;

end;

end.
