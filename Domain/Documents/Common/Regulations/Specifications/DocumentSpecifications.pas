unit DocumentSpecifications;

interface

uses

  DocumentSigningSpecification,
  DocumentChargesSpecification,
  DocumentPerformingSpecification,
  SysUtils;

type

  IDocumentSpecifications = interface

    function GetDocumentSigningSpecification: IDocumentSigningSpecification;
    procedure SetDocumentSigningSpecification(Value: IDocumentSigningSpecification);

    function GetDocumentChargesSpecification: IDocumentChargesSpecification;
    procedure SetDocumentChargesSpecification(Value: IDocumentChargesSpecification);

    function GetDocumentPerformingSpecification: IDocumentPerformingSpecification;
    procedure SetDocumentPerformingSpecification(Value: IDocumentPerformingSpecification);

    property DocumentSigningSpecification: IDocumentSigningSpecification
    read GetDocumentSigningSpecification write SetDocumentSigningSpecification;

    property DocumentChargesSpecification: IDocumentChargesSpecification
    read GetDocumentChargesSpecification write SetDocumentChargesSpecification;

    property DocumentPerformingSpecification: IDocumentPerformingSpecification
    read GetDocumentPerformingSpecification write SetDocumentPerformingSpecification;

  end;

  TDocumentSpecifications = class (TInterfacedObject, IDocumentSpecifications)

    private

      FDocumentSigningSpecification: IDocumentSigningSpecification;
      FDocumentChargesSpecification: IDocumentChargesSpecification;
      FDocumentPerformingSpecification: IDocumentPerformingSpecification;
      
    public

      constructor Create(
        DocumentSigningSpecification: IDocumentSigningSpecification;
        DocumentChargesSpecification: IDocumentChargesSpecification;
        DocumentPerformingSpecification: IDocumentPerformingSpecification
      );

      function GetDocumentSigningSpecification: IDocumentSigningSpecification;
      procedure SetDocumentSigningSpecification(Value: IDocumentSigningSpecification);

      function GetDocumentChargesSpecification: IDocumentChargesSpecification;
      procedure SetDocumentChargesSpecification(Value: IDocumentChargesSpecification);

      function GetDocumentPerformingSpecification: IDocumentPerformingSpecification;
      procedure SetDocumentPerformingSpecification(Value: IDocumentPerformingSpecification);

      property DocumentSigningSpecification: IDocumentSigningSpecification
      read GetDocumentSigningSpecification write SetDocumentSigningSpecification;

      property DocumentChargesSpecification: IDocumentChargesSpecification
      read GetDocumentChargesSpecification write SetDocumentChargesSpecification;

      property DocumentPerformingSpecification: IDocumentPerformingSpecification
      read GetDocumentPerformingSpecification write SetDocumentPerformingSpecification;

  end;
  
implementation

{ TDocumentSpecifications }

constructor TDocumentSpecifications.Create(
  DocumentSigningSpecification: IDocumentSigningSpecification;
  DocumentChargesSpecification: IDocumentChargesSpecification;
  DocumentPerformingSpecification: IDocumentPerformingSpecification
);
begin

  inherited Create;

  FDocumentSigningSpecification := DocumentSigningSpecification;
  FDocumentChargesSpecification := DocumentChargesSpecification;
  FDocumentPerformingSpecification := DocumentPerformingSpecification;
    
end;

function TDocumentSpecifications.GetDocumentChargesSpecification: IDocumentChargesSpecification;
begin

  Result := FDocumentChargesSpecification;
  
end;

function TDocumentSpecifications.GetDocumentPerformingSpecification: IDocumentPerformingSpecification;
begin

  Result := FDocumentPerformingSpecification;

end;

function TDocumentSpecifications.GetDocumentSigningSpecification: IDocumentSigningSpecification;
begin

  Result := FDocumentSigningSpecification;
  
end;

procedure TDocumentSpecifications.SetDocumentChargesSpecification(
  Value: IDocumentChargesSpecification);
begin

  FDocumentChargesSpecification := Value;

end;

procedure TDocumentSpecifications.SetDocumentPerformingSpecification(
  Value: IDocumentPerformingSpecification);
begin

  FDocumentPerformingSpecification := Value;
  
end;

procedure TDocumentSpecifications.SetDocumentSigningSpecification(
  Value: IDocumentSigningSpecification);
begin

  FDocumentSigningSpecification := Value;
  
end;

end.
