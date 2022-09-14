unit PersonnelOrderSubKindViewModel;

interface

uses

  SysUtils,
  Classes;

type

  TPersonnelOrderSubKindViewModel = class

    public

      Id: Variant;
      Name: String;

      constructor Create;

  end;

  TPersonnelOrderSubKindViewModels = class;

  TPersonnelOrderSubKindViewModelsEnumerator = class (TListEnumerator)

    private

      function GetCurrentPersonnelOrderSubKindViewModel: TPersonnelOrderSubKindViewModel;

    public

      constructor Create(PersonnelOrderSubKindViewModels: TPersonnelOrderSubKindViewModels);

      property Current: TPersonnelOrderSubKindViewModel
      read GetCurrentPersonnelOrderSubKindViewModel;
      
  end;

  TPersonnelOrderSubKindViewModels = class (TList)

    private

      function GetPersonnelOrderSubKindViewModelByIndex(
        Index: Integer
      ): TPersonnelOrderSubKindViewModel;

      procedure SetPersonnelOrderSubKindViewModelByIndex(
        Index: Integer;
        const Value: TPersonnelOrderSubKindViewModel
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function GetEnumerator: TPersonnelOrderSubKindViewModelsEnumerator;

      property Items[Index: Integer]: TPersonnelOrderSubKindViewModel
      read GetPersonnelOrderSubKindViewModelByIndex
      write SetPersonnelOrderSubKindViewModelByIndex; default;
      
  end;
  
implementation

uses

  Variants;

{ TPersonnelOrderSubKindViewModel }

constructor TPersonnelOrderSubKindViewModel.Create;
begin

  inherited;

  Id := Null;
  
end;

{ TPersonnelOrderSubKindViewModelsEnumerator }

constructor TPersonnelOrderSubKindViewModelsEnumerator.Create(
  PersonnelOrderSubKindViewModels: TPersonnelOrderSubKindViewModels);
begin

  inherited Create(PersonnelOrderSubKindViewModels);

end;

function TPersonnelOrderSubKindViewModelsEnumerator.
  GetCurrentPersonnelOrderSubKindViewModel: TPersonnelOrderSubKindViewModel;
begin

  Result := TPersonnelOrderSubKindViewModel(GetCurrent);
  
end;

{ TPersonnelOrderSubKindViewModels }

function TPersonnelOrderSubKindViewModels.GetEnumerator: TPersonnelOrderSubKindViewModelsEnumerator;
begin

  Result := TPersonnelOrderSubKindViewModelsEnumerator.Create(Self);

end;

function TPersonnelOrderSubKindViewModels.GetPersonnelOrderSubKindViewModelByIndex(
  Index: Integer): TPersonnelOrderSubKindViewModel;
begin

  Result := TPersonnelOrderSubKindViewModel(Get(Index));

end;

procedure TPersonnelOrderSubKindViewModels.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  inherited;

  if Action = lnDeleted then
    TPersonnelOrderSubKindViewModel(Ptr).Free;
  
end;

procedure TPersonnelOrderSubKindViewModels.SetPersonnelOrderSubKindViewModelByIndex(
  Index: Integer; const Value: TPersonnelOrderSubKindViewModel);
begin

  Put(Index, Value);

end;

end.
