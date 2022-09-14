unit SDItem;

interface

uses

  SysUtils,
  Classes;

type

  TSDItem = class

    private

      FId: Variant;
      FTopLevelSDItemId: Variant;
      FName: String;

    public

      constructor Create;

    published

      property Id: Variant read FId write FId;
      property TopLevelSDItemId: Variant read FTopLevelSDItemId write FTopLevelSDItemId;
      property Name: String read FName write FName;
      
  end;

  TSDItems = class;

  TSDItemsEnumerator = class (TListEnumerator)

    private

      function GetCurrentSDItem: TSDItem;

    public

      constructor Create(SDItems: TSDItems);

      property Current: TSDItem read GetCurrentSDItem;

  end;

  TSDItems = class (TList)

    private

      function GetSDItemByIndex(Index: Integer): TSDItem;
      procedure SetSDItemByIndex(Index: Integer; const Value: TSDItem);

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function Add(SDItem: TSDItem): Integer;
      procedure Remove(SDItem: TSDItem);

      function FindById(const SDItemId: Variant): TSDItem;
      
      function GetEnumerator: TSDItemsEnumerator;

      property Items[Index: Integer]: TSDItem
      read GetSDItemByIndex write SetSDItemByIndex; default;

  end;

implementation

uses

  Variants;

{ TSDItem }

constructor TSDItem.Create;
begin

  inherited;

  Id := Null;
  TopLevelSDItemId := Null;
  
end;

{ TSDItemsEnumerator }

constructor TSDItemsEnumerator.Create(SDItems: TSDItems);
begin

  inherited Create(SDItems);

end;

function TSDItemsEnumerator.GetCurrentSDItem: TSDItem;
begin

  Result := TSDItem(GetCurrent);
  
end;

{ TSDItems }

function TSDItems.Add(SDItem: TSDItem): Integer;
begin

  Result := inherited Add(SDItem);

end;

function TSDItems.FindById(const SDItemId: Variant): TSDItem;
begin

  for Result in Self do
    if Result.Id = SDItemId then
      Exit;

  Result := nil;
    
end;

function TSDItems.GetEnumerator: TSDItemsEnumerator;
begin

  Result := TSDItemsEnumerator.Create(Self);

end;

function TSDItems.GetSDItemByIndex(Index: Integer): TSDItem;
begin

  Result := TSDItem(Get(Index));

end;

procedure TSDItems.Notify(Ptr: Pointer; Action: TListNotification);
begin

  inherited;

  if (Action = lnDeleted) and Assigned(Ptr) then
    TSDItem(Ptr).Destroy;

end;

procedure TSDItems.Remove(SDItem: TSDItem);
var SDItemIndex: Integer;
begin

  SDItemIndex := IndexOf(SDItem);

  if SDItemIndex <> -1 then
    Delete(SDItemIndex);

end;

procedure TSDItems.SetSDItemByIndex(Index: Integer; const Value: TSDItem);
begin

  Put(Index, Value);
  
end;

end.
