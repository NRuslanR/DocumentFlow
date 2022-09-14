unit BasedOnDatabaseSDItemsService;

interface

uses

  SDItemsService,
  SysUtils,
  SDBaseTableFormUnit,
  SDItem,
  Classes,
  Controls;

type

  TBasedOnDatabaseSDItemsService = class (TInterfacedObject, ISDItemsService)

    public

      function GetSelf: TObject;
      
    public

      constructor Create(DatabaseConnection: TComponent); virtual; abstract;
      
      function GetAllSDItems: TSDItems; virtual; abstract;
      function GetSDItemControl(const SDItemId: Variant): TWinControl; virtual; abstract;

  end;
  
implementation

{ TBasedOnDatabaseSDItemsService }

function TBasedOnDatabaseSDItemsService.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
