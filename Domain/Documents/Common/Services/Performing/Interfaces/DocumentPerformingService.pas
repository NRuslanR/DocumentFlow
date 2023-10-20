unit DocumentPerformingService;

interface

uses

  IDocumentUnit,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  DomainException,
  Employee;

type

  TDocumentPerformingServiceException = class (TDomainException)

  end;
  
  IDocumentPerformingService = interface
    ['{0ED069BF-7359-47F9-929A-E4746B24A271}']

    procedure PerformDocument(
      Document: IDocument;
      DocumentChargeSheet: IDocumentChargeSheet
    ); overload;

    function PerformDocument(
      const DocumentId: Variant;
      DocumentChargeSheet: IDocumentChargeSheet
    ): IDocument; overload;

    procedure PerformDocument(
      Document: IDocument;
      DocumentChargeSheets: TDocumentChargeSheets
    ); overload;

    function PerformDocument(
      const DocumentId: Variant;
      DocumentChargeSheets: TDocumentChargeSheets
    ): IDocument; overload;
    
  end;

implementation

end.
