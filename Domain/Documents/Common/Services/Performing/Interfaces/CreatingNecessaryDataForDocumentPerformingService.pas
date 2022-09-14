unit CreatingNecessaryDataForDocumentPerformingService;

interface

uses

  Document,
  IDocumentUnit,
  DomainException,
  DomainObjectValueUnit,
  IDomainObjectBaseListUnit,
  DocumentChargeSheet,
  Employee,
  SysUtils,
  Classes;

type

  TNecessaryDataForDocumentPerforming = class (TDomainObjectValue)

    protected

      FDocumentChargeSheets: TDocumentChargeSheets;
      FFreeDocumentChargeSheets: IDomainObjectBaseList;
      
      function GetDocumentChargeSheets: TDocumentChargeSheets;
      procedure SetDocumentChargeSheets(Value: TDocumentChargeSheets);
      
    public

      constructor Create; virtual;
      constructor CreateFrom(DocumentChargeSheets: TDocumentChargeSheets); virtual;

    public

      property DocumentChargeSheets: TDocumentChargeSheets
      read GetDocumentChargeSheets write SetDocumentChargeSheets;

  end;

  TNecessaryDataForDocumentPerformingClass = class of TNecessaryDataForDocumentPerforming;
  
  TCreatingNecessaryDataForDocumentPerformingServiceException = class (TDomainException)

  end;
  
  ICreatingNecessaryDataForDocumentPerformingService = interface
    ['{D625D69D-6002-40F3-BF41-745E76D03833}']
    
    function CreateNecessaryDataForDocumentPerforming(
      Document: IDocument;
      InitiatingEmployee: TEmployee
    ): TNecessaryDataForDocumentPerforming;

  end;

implementation

uses

  Variants;

{ TNecessaryDataForDocumentPerforming }

constructor TNecessaryDataForDocumentPerforming.Create;
begin

  inherited;

end;

constructor TNecessaryDataForDocumentPerforming.CreateFrom(
  DocumentChargeSheets: TDocumentChargeSheets
);
begin

  inherited Create;

  Self.DocumentChargeSheets := DocumentChargeSheets;

end;

function TNecessaryDataForDocumentPerforming.GetDocumentChargeSheets:
  TDocumentChargeSheets;
begin

  Result := FDocumentChargeSheets;

end;

procedure TNecessaryDataForDocumentPerforming.SetDocumentChargeSheets(
  Value: TDocumentChargeSheets);
begin

  FDocumentChargeSheets := Value;
  FFreeDocumentChargeSheets := FDocumentChargeSheets;

end;

end.
