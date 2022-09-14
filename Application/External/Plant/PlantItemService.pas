{ refactor: temporary solution before DocumentFlowItemService implementation }
unit PlantItemService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils,
  Classes;

type

  TPlantItem = class

    Id: Variant;
    Name: String;

  end;

  TPlantItems = class;

  TPlantItemsEnumerator = class (TListEnumerator)

    private

      function GetCurrentPlantItem: TPlantItem;

    public

      constructor Create(PlantItems: TPlantItems);

      property Current: TPlantItem read GetCurrentPlantItem;

  end;

  TPlantItems = class (TList)

    private
    
      function GetPlantItemByIndex(Index: Integer): TPlantItem;
      procedure SetPlantItemByIndex(Index: Integer; const Value: TPlantItem);
      
    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      procedure Add(Item: TPlantItem);

      function GetEnumerator: TPlantItemsEnumerator;

      property Items[Index: Integer]: TPlantItem
      read GetPlantItemByIndex write SetPlantItemByIndex; default;

  end;
  
  IPlantItemService = interface (IApplicationService)

    function GetPlantItems(const ClientId: Variant): TPlantItems;
    function GetPlantItemControl(const ClientId: Variant; const PlantItemId: Variant): TControl;

  end;

implementation

{ TPlantItemsEnumerator }

constructor TPlantItemsEnumerator.Create(PlantItems: TPlantItems);
begin

  inherited Create(PlantItems);
  
end;

function TPlantItemsEnumerator.GetCurrentPlantItem: TPlantItem;
begin

  Result := TPlantItem(GetCurrent);
  
end;

{ TPlantItems }

procedure TPlantItems.Add(Item: TPlantItem);
begin

  inherited Add(Item);

end;

function TPlantItems.GetEnumerator: TPlantItemsEnumerator;
begin

  Result := TPlantItemsEnumerator.Create(Self);
  

end;

function TPlantItems.GetPlantItemByIndex(Index: Integer): TPlantItem;
begin

  Result := TPlantItem(Get(Index));

end;

procedure TPlantItems.Notify(Ptr: Pointer; Action: TListNotification);
begin

  inherited Notify(Ptr, Action);

  if Action = lnDeleted then
    TObject(Ptr).Free;
    
end;

procedure TPlantItems.SetPlantItemByIndex(Index: Integer;
  const Value: TPlantItem);
begin

  Put(Index, Value);

end;

end.
