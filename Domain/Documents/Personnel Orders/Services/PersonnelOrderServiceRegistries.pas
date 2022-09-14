unit PersonnelOrderServiceRegistries;

interface

uses

  PersonnelOrderAccessServiceRegistry,
  PersonnelOrderControlServiceRegistry,
  PersonnelOrderSearchServiceRegistry,
  SysUtils;

type

  TPersonnelOrderServiceRegistries = class

    public

      class procedure Destroy;
      
      class function PersonnelOrderAccessServiceRegistry: TPersonnelOrderAccessServiceRegistry;
      class function PersonnelOrderControlServiceRegistry: TPersonnelOrderControlServiceRegistry;
      class function PersonnelOrderSearchServiceRegistry: TPersonnelOrderSearchServiceRegistry;

  end;

  TPersonnelOrderServiceRegistriesClass = class of TPersonnelOrderServiceRegistries;
  
implementation

{ TPersonnelOrderServiceRegistries }

class procedure TPersonnelOrderServiceRegistries.Destroy;
begin

  PersonnelOrderAccessServiceRegistry.Free;
  PersonnelOrderControlServiceRegistry.Free;
  PersonnelOrderSearchServiceRegistry.Free;

end;

class function TPersonnelOrderServiceRegistries.PersonnelOrderAccessServiceRegistry: TPersonnelOrderAccessServiceRegistry;
begin

  Result := TPersonnelOrderAccessServiceRegistry.Instance;
  
end;

class function TPersonnelOrderServiceRegistries.PersonnelOrderControlServiceRegistry: TPersonnelOrderControlServiceRegistry;
begin

  Result := TPersonnelOrderControlServiceRegistry.Instance;

end;

class function TPersonnelOrderServiceRegistries.PersonnelOrderSearchServiceRegistry: TPersonnelOrderSearchServiceRegistry;
begin

  Result := TPersonnelOrderSearchServiceRegistry.Instance;
  
end;

end.
