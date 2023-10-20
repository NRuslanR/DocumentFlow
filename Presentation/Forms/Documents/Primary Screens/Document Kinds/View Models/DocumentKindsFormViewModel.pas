unit DocumentKindsFormViewModel;

interface

uses

  DocumentKindSetHolder,
  SysUtils,
  Classes;

type

  TDocumentKindsFormViewModel = class

    private

      FDocumentKindSetHolder: TDocumentKindSetHolder;
      
      procedure SetDocumentKindSetHolder(const Value: TDocumentKindSetHolder);

    public

      destructor Destroy; override;
      constructor Create; overload;
      constructor Create(DocumentKindSetHolder: TDocumentKindSetHolder); overload;

      function ExcludeDocumentKindSetHolder: TDocumentKindSetHolder;
      
      property DocumentKindSetHolder: TDocumentKindSetHolder
      read FDocumentKindSetHolder write SetDocumentKindSetHolder;
      
  end;


implementation

{ TDocumentKindsFormViewModel }

constructor TDocumentKindsFormViewModel.Create;
begin

  inherited;

end;

constructor TDocumentKindsFormViewModel.Create(
  DocumentKindSetHolder: TDocumentKindSetHolder);
begin

  inherited Create;

  Self.DocumentKindSetHolder := DocumentKindSetHolder;

end;

destructor TDocumentKindsFormViewModel.Destroy;
begin

  FreeAndNil(FDocumentKindSetHolder);
  
  inherited;

end;

function TDocumentKindsFormViewModel.ExcludeDocumentKindSetHolder: TDocumentKindSetHolder;
begin

  Result := FDocumentKindSetHolder;

  FDocumentKindSetHolder := nil;
  
end;

procedure TDocumentKindsFormViewModel.SetDocumentKindSetHolder(
  const Value: TDocumentKindSetHolder);
begin

  if FDocumentKindSetHolder = Value then Exit;

  FreeAndNil(FDocumentKindSetHolder);
  
  FDocumentKindSetHolder := Value;

end;

end.
