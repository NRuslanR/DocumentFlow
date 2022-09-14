unit PersonnelOrderAccessServiceRegistry;

interface

uses

  PersonnelOrderCreatingAccessService,
  PersonnelOrderCreatingAccessEmployeeList,
  PersonnelOrderCreatingAccessEmployeeListFinder,
  PersonnelOrderSingleEmployeeListFinder,
  TypeObjectRegistry,
  SysUtils;

type

  TPersonnelOrderAccessServiceRegistry = class

    private

      FInternalRegistry: TTypeObjectRegistry;

    private

      class var FInstance: TPersonnelOrderAccessServiceRegistry;

      constructor Create;

      class function GetInstance: TPersonnelOrderAccessServiceRegistry; static;

      class procedure SetInstance(
        const Value: TPersonnelOrderAccessServiceRegistry
      ); static;

    public

      procedure RegisterPersonnelOrderCreatingAccessService(
        PersonnelOrderCreatingAccessService: IPersonnelOrderCreatingAccessService
      );

      procedure RegisterStandardPersonnelOrderCreatingAccessService;

      function GetPersonnelOrderCreatingAccessService: IPersonnelOrderCreatingAccessService;

    public

      destructor Destroy; override;

      class property Instance: TPersonnelOrderAccessServiceRegistry
      read GetInstance write SetInstance;

  end;
  
implementation

uses

  PersonnelOrderSearchServiceRegistry,
  StandardPersonnelOrderCreatingAccessService;
  
type

  TPersonnelOrderCreatingAccessServiceType = class
  
  end;

{ TPersonnelOrderAccessServiceRegistry }

constructor TPersonnelOrderAccessServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TPersonnelOrderAccessServiceRegistry.Destroy;
begin

  inherited;
end;

class function TPersonnelOrderAccessServiceRegistry.GetInstance: TPersonnelOrderAccessServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TPersonnelOrderAccessServiceRegistry.Create;

  Result := FInstance;
  
end;

function TPersonnelOrderAccessServiceRegistry.GetPersonnelOrderCreatingAccessService: IPersonnelOrderCreatingAccessService;
begin

  Result :=
    IPersonnelOrderCreatingAccessService(
      FInternalRegistry.GetInterface(TPersonnelOrderCreatingAccessServiceType)
    );
  
end;

procedure TPersonnelOrderAccessServiceRegistry.RegisterPersonnelOrderCreatingAccessService(
  PersonnelOrderCreatingAccessService: IPersonnelOrderCreatingAccessService);
begin

  FInternalRegistry.RegisterInterface(
    TPersonnelOrderCreatingAccessServiceType,
    PersonnelOrderCreatingAccessService
  );

end;

procedure TPersonnelOrderAccessServiceRegistry.RegisterStandardPersonnelOrderCreatingAccessService;
begin

  RegisterPersonnelOrderCreatingAccessService(

    TStandardPersonnelOrderCreatingAccessService.Create(

        TPersonnelOrderSearchServiceRegistry
          .Instance
            .GetPersonnelOrderCreatingAccessEmployeeFinder
      )

  );

end;

class procedure TPersonnelOrderAccessServiceRegistry.SetInstance(
  const Value: TPersonnelOrderAccessServiceRegistry);
begin

  FInstance := Value;
  
end;

end.
