unit DocumentPerformingService;

interface

uses

  Document,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  Employee;

type
    
  IDocumentPerformingService = interface
    ['{0ED069BF-7359-47F9-929A-E4746B24A271}']

    procedure PerformDocument(
      Document: TDocument;
      DocumentChargeSheet: IDocumentChargeSheet
    );

  end;

implementation

end.
