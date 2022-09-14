unit DocumentApprovingSheetViewModel;

interface

uses

  DocumentApprovingSheetApprovingSetHolder,
  SysUtils;
  
type

  TDocumentApprovingSheetViewModel = class

    protected

      FDocumentKindName: String;
      FDocumentName: String;
      FApprovingSetHolder: TDocumentApprovingSheetApprovingSetHolder;

      procedure SetApprovingSetHolder(
        const Value: TDocumentApprovingSheetApprovingSetHolder
      );
      
    public

      destructor Destroy; override;

      property DocumentKindName: String read FDocumentKindName write FDocumentKindName;

      property DocumentName: String read FDocumentName write FDocumentName;
      
      property ApprovingSetHolder: TDocumentApprovingSheetApprovingSetHolder
      read FApprovingSetHolder write SetApprovingSetHolder;
      
  end;


implementation

{ TDocumentApprovingSheetViewModel }

destructor TDocumentApprovingSheetViewModel.Destroy;
begin

  FreeAndNil(FApprovingSetHolder);
  
  inherited;

end;

procedure TDocumentApprovingSheetViewModel.SetApprovingSetHolder(
  const Value: TDocumentApprovingSheetApprovingSetHolder
);
begin

  if FApprovingSetHolder = Value then
    Exit;

  FreeAndNil(FApprovingSetHolder);
  
  FApprovingSetHolder := Value;

end;

end.
