unit DocumentApprovingsFormViewModel;

interface

uses

  DocumentApprovingCycleSetHolder,
  Disposable,
  SysUtils,
  Classes;

type

  TDocumentApprovingsFormViewModel = class

    protected

      function GetDocumentApprovingSetHolder: TDocumentApprovingSetHolder;

      procedure SetDocumentApprovingSetHolder(
        const Value: TDocumentApprovingSetHolder
      );

    protected

      FDocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
      FFreeDocumentApprovingCycleSetHolder: IDisposable;
      
      procedure SetDocumentApprovingCycleSetHolder(
        const Value: TDocumentApprovingCycleSetHolder
      );

    public

      destructor Destroy; override;

      constructor Create;
      constructor CreateFrom(
        DocumentApprovingCycleSetHolder:
          TDocumentApprovingCycleSetHolder
      );

    published

      property DocumentApprovingCycleSetHolder:
        TDocumentApprovingCycleSetHolder
      read FDocumentApprovingCycleSetHolder
      write SetDocumentApprovingCycleSetHolder;

      property DocumentApprovingSetHolder:
        TDocumentApprovingSetHolder
      read GetDocumentApprovingSetHolder
      write SetDocumentApprovingSetHolder;
      
  end;
  
implementation

{ TDocumentApprovingsFormViewModel }

constructor TDocumentApprovingsFormViewModel.Create;
begin

  inherited;
  
end;

constructor TDocumentApprovingsFormViewModel.CreateFrom(
  DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder
);
begin

  inherited;

  Self.DocumentApprovingCycleSetHolder :=
    DocumentApprovingCycleSetHolder;

end;

destructor TDocumentApprovingsFormViewModel.Destroy;
begin

  inherited;

end;

function TDocumentApprovingsFormViewModel.GetDocumentApprovingSetHolder: TDocumentApprovingSetHolder;
begin

  Result :=
    FDocumentApprovingCycleSetHolder.DocumentApprovingSetHolder;
    
end;

procedure TDocumentApprovingsFormViewModel.
  SetDocumentApprovingCycleSetHolder(
    const Value: TDocumentApprovingCycleSetHolder
  );
begin

  FDocumentApprovingCycleSetHolder := Value;
  FFreeDocumentApprovingCycleSetHolder := Value;
  
end;

procedure TDocumentApprovingsFormViewModel.SetDocumentApprovingSetHolder(
  const Value: TDocumentApprovingSetHolder);
begin

  FDocumentApprovingCycleSetHolder.DocumentApprovingSetHolder :=
    Value;
    
end;

end.
