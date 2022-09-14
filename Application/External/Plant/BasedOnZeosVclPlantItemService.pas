{ refactor: temporary solution before DocumentFlowItemService implementation }
unit BasedOnZeosVclPlantItemService;

interface

uses

  AbstractApplicationService,
  PlantStructureAccessService,
  PlantItemService,
  Controls,
  SysUtils,
  UnPodrTree,
  UnDocAdminLib,
  ZConnection,
  Classes;

type

  TBasedOnZeosVclPlantItemService = class (TAbstractApplicationService, IPlantItemService)

    private

      FZConnection: TZConnection;
      FPlantStructureAccessService: IPlantStructureAccessService;

    public

      constructor Create(
        ZConnection: TZConnection;
        PlantStructureAccessService: IPlantStructureAccessService
      );

      function GetPlantItems(const ClientId: Variant): TPlantItems;
      function GetPlantItemControl(const ClientId: Variant; const PlantItemId: Variant): TControl;
    
  end;
  
implementation

{ TBasedOnZeosVclPlantItemService }

constructor TBasedOnZeosVclPlantItemService.Create(
  ZConnection: TZConnection;
  PlantStructureAccessService: IPlantStructureAccessService
);
begin

  inherited Create;

  FZConnection := ZConnection;
  FPlantStructureAccessService := PlantStructureAccessService;
  
end;

function TBasedOnZeosVclPlantItemService.GetPlantItemControl(
  const ClientId: Variant;
  const PlantItemId: Variant
): TControl;
begin
  
  case PlantItemId of

    1:
    begin

      FPlantStructureAccessService.EnsureEmployeeHasPlantStructureAccess(ClientId);
      
      Result := InitPodrTree(FZConnection, UnDocAdminLib.view_);

      with TfrmPodrTree(Result) do ExitToolVisible := False;
      
    end;

    else Raise Exception.Create('Неверный идентификатор для элемента "Структура предприятия"');
    
  end;

end;

function TBasedOnZeosVclPlantItemService.GetPlantItems(const ClientId: Variant): TPlantItems;
begin

  Result := TPlantItems.Create;

  if not FPlantStructureAccessService.HasEmployeePlantStructureAccess(ClientId)
  then Exit;
  
  Result.Add(TPlantItem.Create);

  with Result[0] do begin

    Id := 1;
    Name := 'Структура предприятия';

  end;

end;

end.
