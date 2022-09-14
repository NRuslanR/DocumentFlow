unit _ApplicationServiceRegistry;

interface

uses

  ApplicationService,
  SysUtils,
  Classes,
  TypeObjectRegistry,
  IGetSelfUnit;

type

  TUsingServiceTypeAsTargetOption =
    (
      optUseServiceTypeIfTargetDescdendentServiceNotFound,
      optNotUseServiceTypeIfTargetDescdendentServiceNotFound
    );
    
  TApplicationServiceRegistry = class

    private

      function GetUseSearchByNearestAncestorTypeIfTargetServiceNotFound: Boolean;
      procedure SetUseSearchByNearestAncestorTypeIfTargetServiceNotFound(
        const Value: Boolean);


    protected

      FInternalRegsitry: TTypeObjectRegistry;

    public

      procedure RegisterApplicationService(
        Key: TClass;
        Service: IApplicationService;
        ServiceOption: TUsingServiceTypeAsTargetOption = optUseServiceTypeIfTargetDescdendentServiceNotFound
      );

      function GetApplicationService(
        Key: TClass
      ): IApplicationService;

    public { debug }

      procedure AddServiceNames(ServiceNames: TStrings); virtual;

    public

      destructor Destroy; override;
      constructor Create; virtual;

      property UseSearchByNearestAncestorTypeIfTargetServiceNotFound: Boolean
      read GetUseSearchByNearestAncestorTypeIfTargetServiceNotFound
      write SetUseSearchByNearestAncestorTypeIfTargetServiceNotFound;
      
  end;

implementation

uses

  AuxDebugFunctionsUnit;
  
{ TApplicationServiceRegistry }


procedure TApplicationServiceRegistry.AddServiceNames(ServiceNames: TStrings);
var
    Item: ITypeObjectRegistryItem;
    Service: IApplicationService;
    Pos: Integer;
begin

  Pos := ServiceNames.Count;
  
  for Item in FInternalRegsitry do begin

    if Assigned(Item.RegistryObject) then
      ServiceNames.Add(Item.RegistryObject.ClassName)

    else begin

      Service := IApplicationService(Item.RegistryInterface);

      if ServiceNames.IndexOf(Service.Self.ClassName) = -1 then
        ServiceNames.Add(Service.Self.ClassName);

    end;

  end;

end;

constructor TApplicationServiceRegistry.Create;
begin

  inherited Create;

  FInternalRegsitry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  UseSearchByNearestAncestorTypeIfTargetServiceNotFound := True;
  
end;

destructor TApplicationServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegsitry);

  inherited;

end;

function TApplicationServiceRegistry.GetApplicationService(
  Key: TClass): IApplicationService;
begin

  Result := IApplicationService(FInternalRegsitry.GetInterface(Key));
  
end;

procedure TApplicationServiceRegistry.RegisterApplicationService(
  Key: TClass;
  Service: IApplicationService;
  ServiceOption: TUsingServiceTypeAsTargetOption
);
begin

  FInternalRegsitry.RegisterInterface(
    Key,
    Service,
    TTypeObjectRegistrationOptions.Create.AllowObjectUsingByTypeInheritance(
      ServiceOption = optUseServiceTypeIfTargetDescdendentServiceNotFound
    )
  );

end;

function TApplicationServiceRegistry.
  GetUseSearchByNearestAncestorTypeIfTargetServiceNotFound: Boolean;
begin

  Result := FInternalRegsitry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound;

end;

procedure TApplicationServiceRegistry.SetUseSearchByNearestAncestorTypeIfTargetServiceNotFound(
  const Value: Boolean);
begin

  FInternalRegsitry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := Value;
  
end;

end.

