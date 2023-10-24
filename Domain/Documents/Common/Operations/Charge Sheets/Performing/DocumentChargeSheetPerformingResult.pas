unit DocumentChargeSheetPerformingResult;

interface

uses

  IDocumentUnit,
  DomainObjectValueUnit,
  IDocumentChargeSheetUnit,
  SysUtils;

type

  TDocumentChargeSheetPerformingResult = class (TDomainObjectValue)

    private

      FPerformedDocument: IDocument;
      FPerformedChargeSheets: IDocumentChargeSheets;

    public

      constructor Create(PerformedChargeSheets: IDocumentChargeSheets); overload;

      constructor Create(
        PerformedDocument: IDocument;
        PerformedChargeSheets: IDocumentChargeSheets
      ); overload;

    published

      property PerformedDocument: IDocument
      read FPerformedDocument write FPerformedDocument;

      property PerformedChargeSheets: IDocumentChargeSheets
      read FPerformedChargeSheets write FPerformedChargeSheets;

  end;

implementation

{ TDocumentChargeSheetPerformingResult }

constructor TDocumentChargeSheetPerformingResult.Create(
  PerformedChargeSheets: IDocumentChargeSheets
);
begin

  inherited Create;

  FPerformedChargeSheets := PerformedChargeSheets;
  
end;

constructor TDocumentChargeSheetPerformingResult.Create(
  PerformedDocument: IDocument;
  PerformedChargeSheets: IDocumentChargeSheets
);
begin

  inherited Create;

  FPerformedDocument := PerformedDocument;
  FPerformedChargeSheets := PerformedChargeSheets;

end;

end.
