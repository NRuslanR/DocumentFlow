unit PersonnelOrderControlServiceRegistry;

interface

uses

  PersonnelOrderControlService,
  TypeObjectRegistry,
  PersonnelOrderControlGroup,
  SysUtils;

type

  TPersonnelOrderControlServiceRegistry = class

    private

      FInternalRegistry: TTypeObjectRegistry;

      class var FInstance: TPersonnelOrderControlServiceRegistry;

      class function GetInstance: TPersonnelOrderControlServiceRegistry; static;

      class procedure SetInstance(
        const Value: TPersonnelOrderControlServiceRegistry
      ); static;

    public

      destructor Destroy; override;
      constructor Create;

    public

      procedure RegisterPersonnelOrderControlService(
        PersonnelOrderControlService: IPersonnelOrderControlService
      );

      function GetPersonnelOrderControlService: IPersonnelOrderControlService;

      procedure RegisterStandardPersonnelOrderControlService;

    public

      class property Instance: TPersonnelOrderControlServiceRegistry
      read GetInstance write SetInstance;

  end;

implementation

uses

  PersonnelOrderControlGroupFinder,
  StandardPersonnelOrderControlService,
  PersonnelOrderSearchServiceRegistry;

type

  TPersonnelOrderControlServiceType = class

  end;

{ TPersonnelOrderControlServiceRegistry }

constructor TPersonnelOrderControlServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

end;

destructor TPersonnelOrderControlServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

class function TPersonnelOrderControlServiceRegistry.GetInstance: TPersonnelOrderControlServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TPersonnelOrderControlServiceRegistry.Create;

  Result := FInstance;

end;

function TPersonnelOrderControlServiceRegistry.GetPersonnelOrderControlService: IPersonnelOrderControlService;
begin

  Result :=
    IPersonnelOrderControlService(
      FInternalRegistry.GetInterface(TPersonnelOrderControlServiceType)
    );

end;

procedure TPersonnelOrderControlServiceRegistry.RegisterPersonnelOrderControlService(
  PersonnelOrderControlService: IPersonnelOrderControlService);
begin

  FInternalRegistry.RegisterInterface(
    TPersonnelOrderControlServiceType,
    PersonnelOrderControlService
  );

end;

procedure TPersonnelOrderControlServiceRegistry.RegisterStandardPersonnelOrderControlService;
begin

  RegisterPersonnelOrderControlService(

    TStandardPersonnelOrderControlService.Create(

        TPersonnelOrderSearchServiceRegistry
          .Instance
            .GetPersonnelOrderControlGroupFinder

    )

  );

end;

class procedure TPersonnelOrderControlServiceRegistry.SetInstance(
  const Value: TPersonnelOrderControlServiceRegistry);
begin

  FInstance := Value;
  
end;

end.
