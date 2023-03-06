unit ResourceRequestsItemService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils,
  Classes;

type

  TResourceRequestsItem = class

    Id: Variant;
    Name: String;

  end;

  TResourceRequestsItems = class;

  TResourceRequestsItemsEnumerator = class (TListEnumerator)

    private

      function GetCurrentResourceRequestsItem: TResourceRequestsItem;

    public

      constructor Create(ResourceRequestsItems: TResourceRequestsItems);

      property Current: TResourceRequestsItem read GetCurrentResourceRequestsItem;

  end;

  TResourceRequestsItems = class (TList)

    private
    
      function GetResourceRequestsItemByIndex(Index: Integer): TResourceRequestsItem;
      procedure SetResourceRequestsItemByIndex(Index: Integer; const Value: TResourceRequestsItem);
      
    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      procedure Add(Item: TResourceRequestsItem);

      function GetEnumerator: TResourceRequestsItemsEnumerator;

      property Items[Index: Integer]: TResourceRequestsItem
      read GetResourceRequestsItemByIndex write SetResourceRequestsItemByIndex; default;

  end;
  
  IResourceRequestsItemService = interface (IApplicationService)

    function GetResourceRequestsItems(const ClientId: Variant): TResourceRequestsItems;
    function GetResourceRequestsItemControl(const ClientId: Variant; const ResourceRequestsItemId: Variant): TControl;

  end;

implementation

{ TResourceRequestItemsEnumerator }

constructor TResourceRequestsItemsEnumerator.Create(
  ResourceRequestsItems: TResourceRequestsItems);
begin
  inherited Create(ResourceRequestsItems);
end;

function TResourceRequestsItemsEnumerator.GetCurrentResourceRequestsItem: TResourceRequestsItem;
begin
  Result := TResourceRequestsItem(GetCurrent);
end;

{ TResourceRequestItems }

procedure TResourceRequestsItems.Add(Item: TResourceRequestsItem);
begin
  inherited Add(Item);
end;

function TResourceRequestsItems.GetEnumerator: TResourceRequestsItemsEnumerator;
begin
  Result := TResourceRequestsItemsEnumerator.Create(Self);
end;

function TResourceRequestsItems.GetResourceRequestsItemByIndex(
  Index: Integer): TResourceRequestsItem;
begin
  Result := TResourceRequestsItem(Get(Index));
end;

procedure TResourceRequestsItems.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited Notify(Ptr, Action);

  if Action = lnDeleted then
    TObject(Ptr).Free;

end;

procedure TResourceRequestsItems.SetResourceRequestsItemByIndex(Index: Integer;
  const Value: TResourceRequestsItem);
begin
  Put(Index, Value);
end;

end.
