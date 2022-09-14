unit StandardDocumentPerformingSpecification;

interface

uses

  DocumentPerformingSpecification,
  IDocumentUnit,
  DocumentChargeSheetDirectory,
  Document,
  SysUtils,
  Classes;

type

  TStandardDocumentPerformingSpecification =
    class (TInterfacedObject, IDocumentPerformingSpecification)

      private

        FDocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;

      public

        constructor Create(DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory);
        
        function IsDocumentSentToPerforming(Document: IDocument): Boolean;

    end;

implementation

{ TStandardDocumentPerformingSpecification }

constructor TStandardDocumentPerformingSpecification.Create(
  DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory);
begin

  inherited Create;

  FDocumentChargeSheetDirectory := DocumentChargeSheetDirectory;

end;

function TStandardDocumentPerformingSpecification.IsDocumentSentToPerforming(
  Document: IDocument): Boolean;
begin

  Result :=
    FDocumentChargeSheetDirectory.AreChargeSheetsExistsForDocument(
      TDocument(Document.Self)
    );
  
end;

end.
