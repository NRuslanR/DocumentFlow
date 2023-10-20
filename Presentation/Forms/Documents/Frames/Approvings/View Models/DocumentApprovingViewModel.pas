unit DocumentApprovingViewModel;

interface

uses

  SysUtils,
  Classes;

type

  TDocumentApprovingViewModel = class

    public

      ApprovingId: Variant;
      ApproverId: Variant;
      Note: String;

      CanBeChanged: Variant;
      CanBeRemoved: Variant;

      constructor Create;
      
  end;

  TDocumentApprovingsViewModel = class;

  TDocumentApprovingsViewModelEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentApprovingViewModel:
        TDocumentApprovingViewModel;

    public

      constructor Create(
        DocumentApprovingsViewModel: TDocumentApprovingsViewModel
      );

      property Current: TDocumentApprovingViewModel
      read GetCurrentDocumentApprovingViewModel;

  end;
  
  TDocumentApprovingsViewModel = class (TList)

    private

      function GetDocumentApprovingViewModelByIndex(
        Index: Integer
      ): TDocumentApprovingViewModel;

      procedure SetDocumentApprovingViewModelByIndex(
        Index: Integer;
        Value: TDocumentApprovingViewModel
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;
      
    public

      function Add(DocumentApprovingViewModel: TDocumentApprovingViewModel): Integer;
      
      function GetEnumerator: TDocumentApprovingsViewModelEnumerator;

      property Items[Index: Integer]: TDocumentApprovingViewModel
      read GetDocumentApprovingViewModelByIndex
      write SetDocumentApprovingViewModelByIndex; default;
      
  end;
  
implementation

uses

  Variants;

{ TDocumentApprovingViewModel }

constructor TDocumentApprovingViewModel.Create;
begin

  inherited;

  ApprovingId := Null;
  ApproverId := Null;
  
  CanBeChanged := Null;
  CanBeRemoved := Null;
  
end;

{ TDocumentApprovingsViewModelEnumerator }

constructor TDocumentApprovingsViewModelEnumerator.Create(
  DocumentApprovingsViewModel: TDocumentApprovingsViewModel);
begin

  inherited Create(DocumentApprovingsViewModel);
  
end;

function TDocumentApprovingsViewModelEnumerator.
  GetCurrentDocumentApprovingViewModel: TDocumentApprovingViewModel;
begin

  Result := TDocumentApprovingViewModel(GetCurrent);
  
end;

{ TDocumentApprovingsViewModel }

function TDocumentApprovingsViewModel.Add(
  DocumentApprovingViewModel: TDocumentApprovingViewModel): Integer;
begin

  Result := inherited Add(DocumentApprovingViewModel);
  
end;

function TDocumentApprovingsViewModel.GetDocumentApprovingViewModelByIndex(
  Index: Integer): TDocumentApprovingViewModel;
begin

  Result := TDocumentApprovingViewModel(Get(Index));
  
end;

function TDocumentApprovingsViewModel.GetEnumerator: TDocumentApprovingsViewModelEnumerator;
begin

  Result := TDocumentApprovingsViewModelEnumerator.Create(Self);
  
end;

procedure TDocumentApprovingsViewModel.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentApprovingViewModel(Ptr).Destroy;

end;

procedure TDocumentApprovingsViewModel.SetDocumentApprovingViewModelByIndex(
  Index: Integer; Value: TDocumentApprovingViewModel);
begin

  Put(Index, Value);
  
end;

end.
